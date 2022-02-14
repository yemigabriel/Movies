//
//  Cast+CoreDataProperties.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData


extension Cast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cast> {
        return NSFetchRequest<Cast>(entityName: "Cast")
    }

    @NSManaged public var name: String?
    @NSManaged public var profile: String?

}

extension Cast : Identifiable {

}
