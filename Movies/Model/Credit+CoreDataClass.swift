//
//  Credit+CoreDataClass.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData

@objc(Credit)
public class Credit: NSManagedObject, Decodable {
    static let entityName = "Credit"
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfo = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfo] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: managedObjectContext)
        else { fatalError("Could not decode \(Self.entityName)") }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movieId = try container.decode(Int32.self, forKey: .id)
        cast = try container.decode(Set<Cast>?.self, forKey: .cast) as NSSet?
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
