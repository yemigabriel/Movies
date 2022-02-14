//
//  Credit+CoreDataProperties.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData


extension Credit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Credit> {
        return NSFetchRequest<Credit>(entityName: "Credit")
    }

    @NSManaged public var movieId: Int32
    @NSManaged public var cast: NSSet?

}

// MARK: Generated accessors for cast
extension Credit {

    @objc(addCastObject:)
    @NSManaged public func addToCast(_ value: Cast)

    @objc(removeCastObject:)
    @NSManaged public func removeFromCast(_ value: Cast)

    @objc(addCast:)
    @NSManaged public func addToCast(_ values: NSSet)

    @objc(removeCast:)
    @NSManaged public func removeFromCast(_ values: NSSet)

}

extension Credit : Identifiable {

}
