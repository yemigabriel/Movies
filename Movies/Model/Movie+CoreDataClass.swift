//
//  Movie+CoreDataClass.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject, Decodable {

    static let entityName = "Movie"
    
    
    public required convenience init(from decoder: Decoder) throws {
        let contextUserInfoKey = decoder.userInfo.keys.filter({$0 == .context}).isEmpty ? CodingUserInfoKey.detailContext : CodingUserInfoKey.context
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey!] as? NSManagedObjectContext else {
            fatalError("wrong managedObjectContext")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: managedObjectContext)
        else { fatalError("Could not decode \(Self.entityName)") }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            movieId = try container.decode(Int32.self, forKey: .movieId)
            title = try container.decode(String?.self, forKey: .title)
            summary = try container.decode(String?.self, forKey: .summary)
            poster = try container.decode(String?.self, forKey: .poster)
            let date = try container.decode(String.self, forKey: .releaseDate)
            releaseDate = date.toDate()
            
            popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
            
            runtime = try container.decodeIfPresent(Int16.self, forKey: .runtime) ?? 0
            genre = try container.decodeIfPresent(Set<Genre>.self, forKey: .genre) as NSSet?
            credits = try container.decodeIfPresent(Set<Credit>.self, forKey: .credits) as NSSet?
            var selectedCategory = ""
            if let category = decoder.userInfo[.latest!] as? MovieCategory {
                selectedCategory = category.rawValue
            }
            if let category = decoder.userInfo[.popular!] as? MovieCategory {
                selectedCategory = category.rawValue
            }
            if let category = decoder.userInfo[.upcoming!] as? MovieCategory {
                selectedCategory = category.rawValue
            }
            category = selectedCategory
            print("TAG: DECODER: ", category)
        }
        catch {
            print("DECODING ERROR: ", error.localizedDescription)
            print("DECODING ERROR: ", error)
        }
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case title
        case summary = "overview"
        case poster = "poster_path"
        case runtime
        case releaseDate = "release_date"
        case popularity = "popularity"
        case genre = "genres"
        case credits
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
    static let detailContext = CodingUserInfoKey(rawValue: "detailContext")
    static let latest = CodingUserInfoKey(rawValue: MovieCategory.latest.rawValue)
    static let popular = CodingUserInfoKey(rawValue: MovieCategory.popular.rawValue)
    static let upcoming = CodingUserInfoKey(rawValue: MovieCategory.upcoming.rawValue)
        
}
