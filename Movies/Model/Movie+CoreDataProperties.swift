//
//  Movie+CoreDataProperties.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/12/22.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var category: String?
    @NSManaged public var movieId: Int32
    @NSManaged public var popularity: Double
    @NSManaged public var poster: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var runtime: Int16
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var credits: NSSet?
    @NSManaged public var genre: NSSet?

}

// MARK: Generated accessors for credits
extension Movie {

    @objc(addCreditsObject:)
    @NSManaged public func addToCredits(_ value: Credit)

    @objc(removeCreditsObject:)
    @NSManaged public func removeFromCredits(_ value: Credit)

    @objc(addCredits:)
    @NSManaged public func addToCredits(_ values: NSSet)

    @objc(removeCredits:)
    @NSManaged public func removeFromCredits(_ values: NSSet)

}

// MARK: Generated accessors for genre
extension Movie {

    @objc(addGenreObject:)
    @NSManaged public func addToGenre(_ value: Genre)

    @objc(removeGenreObject:)
    @NSManaged public func removeFromGenre(_ value: Genre)

    @objc(addGenre:)
    @NSManaged public func addToGenre(_ values: NSSet)

    @objc(removeGenre:)
    @NSManaged public func removeFromGenre(_ values: NSSet)

}

extension Movie : Identifiable {

}
