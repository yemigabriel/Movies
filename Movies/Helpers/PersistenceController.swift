//
//  PersistenceController.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/9/22.
//

import Foundation
import CoreData
import SwiftUI

struct PersistenceController {
    static var shared = PersistenceController()
    var inMemory:Bool = false
    
    lazy var container: NSPersistentContainer = {
        setUpContainer(inMemory: inMemory)
    }()

    // An initializer to load Core Data, optionally able to use an in-memory store.
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    func setUpContainer(inMemory: Bool = false) -> NSPersistentContainer {
        
        let container = NSPersistentContainer(name: "Movies")
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No store descriptions found")
        }
        
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Error: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }
    
    static var sampleMovies: [Movie] = {
        var controller = PersistenceController(inMemory: true)
        var movies: [Movie] = []
        for i in 0..<10 {
            let movie = Movie(context: controller.container.viewContext)
            movie.movieId = Int32(i)
            movie.title = "Title \(i)"
            movie.summary = "Summary \(i)"
            movie.poster = "/images/\(i).png"
            movies.append(movie)
        }
        return movies
    }()
    
    static var sampleMovie: Movie = {
        var controller = PersistenceController(inMemory: true)
        let movie = Movie(context: controller.container.viewContext)
        movie.movieId = Int32(1)
        movie.title = "Title 1"
        movie.summary = "Summary 1"
        movie.poster = "/image1.png"
        return movie
    }()
}
