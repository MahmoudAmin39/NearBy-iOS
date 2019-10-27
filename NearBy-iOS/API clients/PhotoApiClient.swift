//
//  PhotoApiClient.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

struct PhotoApiClient {
    
    var venueId: String?
    
    @available(iOS 10.0, *)
    var context: NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    var photoRequest: String? {
        get {
            if let id = venueId {
                return "\(Constants.baseUrl)venues/\(id)/photos?client_id=\(Constants.clientId)&client_secret=\(Constants.clientSecret)&v=\(Constants.dateVersion)"
            } else {
                return nil
            }
        }
    }
    
    mutating func getPhotoUrl(forVenue id: String, completion: @escaping (String?) -> ()) {
        self.venueId = id
        // Fetch photo url from core data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        fetchRequest.predicate = NSPredicate(format: "venueId == %@", id)
        do {
            if #available(iOS 10.0, *) {
                let photoUrl = try self.context?.fetch(fetchRequest)
                guard let photoUrls = photoUrl, let firstPhotoUrl = photoUrls.first else {
                    // It is nil
                    sendRequest(forVenue: id, completion: completion)
                    return
                }
                
                let url = firstPhotoUrl.value(forKey: Constants.photoUrl) as? String
                completion(url)
            } else {
                sendRequest(forVenue: id, completion: completion)
            }
            
        } catch let error as NSError {
            print("Error fetching data from Database: \(error.description)")
        }
    }
    
    func sendRequest(forVenue id: String, completion: @escaping (String?) -> ()) {
        // Send the request
        print("Sending request")
        if let requestString = photoRequest {
            guard let url = URL(string: requestString) else {
                let _ = ErrorObject(messageBody: "Wrong request Url", imageName: "cloud", errorCode: .BadRequest)
                completion(nil)
                return
            }
            Alamofire.request(url).validate().responseJSON { response in
                guard response.result.isSuccess else {
                    let error = response.error!.localizedDescription
                    let _ = ErrorObject(messageBody: "Something went wrong !!: \(error)", imageName: "cloud", errorCode: .ServerResponseError)
                    completion(nil)
                    return
                }
                
                guard let jsonResponse = response.result.value as? [String: Any],
                    let responseFromServer = jsonResponse["response"] as? [String: Any], let photos = responseFromServer["photos"] as? [String: Any], let items = photos["items"] as? [Any], let photoJson = items.first as? [String: Any] else {
                        let _ = ErrorObject(messageBody: "Error parsing the data", imageName: "cloud", errorCode: .JSONParseError)
                        completion(nil)
                        return
                }
                
                let photo = Photo(with: photoJson, forVenue: id)
                
                // Save the Photo url to Core data
                if #available(iOS 10.0, *) {
                    if let context = self.context,
                        let entity =  NSEntityDescription.entity(forEntityName: Constants.entityName, in: context),
                        let photo = photo {
                            let photoObejct = NSManagedObject(entity: entity, insertInto: context)
                            photoObejct.setValue(photo.venueId, forKey: Constants.venueId)
                            photoObejct.setValue(photo.fullUrl, forKey: Constants.photoUrl)
                            do {
                                try context.save()
                            } catch let error as NSError {
                                print("Error saving data to Database: \(error.description)")
                            }
                    }
                }
                
                completion(photo?.fullUrl)
            }
        }
    }
}
