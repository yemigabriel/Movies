//
//  Genre+CoreDataClass.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData

@objc(Genre)
public class Genre: NSManagedObject, Decodable {
    static let entityName = "Genre"
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfo = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfo] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: managedObjectContext)
        else { fatalError("Could not decode \(Self.entityName)") }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int16.self, forKey: .id)
        name = try container.decode(String?.self, forKey: .name)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
