//
//  PhotoUrl+CoreDataProperties.swift
//  
//
//  Created by Mahmoud Amin on 10/27/19.
//
//

import Foundation
import CoreData


extension PhotoUrl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoUrl> {
        return NSFetchRequest<PhotoUrl>(entityName: "PhotoUrl")
    }

    @NSManaged public var venueId: String?
    @NSManaged public var photoUrl: String?

}
