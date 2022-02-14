//
//  Cast+CoreDataClass.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData

@objc(Cast)
public class Cast: NSManagedObject, Decodable {
    static let entityName = "Cast"
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfo = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfo] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: managedObjectContext)
        else { fatalError("Could not decode \(Self.entityName)") }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String?.self, forKey: .name)
        profile = try container.decode(String?.self, forKey: .profile)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case profile = "profile_path"
    }
}
