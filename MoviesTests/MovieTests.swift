//
//  MovieTests.swift
//  MoviesTests
//
//  Created by Yemi Gabriel on 2/13/22.
//

import XCTest
@testable import Movies
import CoreData

class MovieTests: XCTestCase {

    var sut: CoreDataHelper!
    var persistenceController = PersistenceController(inMemory: true)
    var container: NSPersistentContainer!
    let entityName = "Movie"
    
    override func setUp() {
        super.setUp()
        container = persistenceController.container
        sut = CoreDataHelper(persistentContainer: container)
        
    }

    override func tearDown() {
        clearData()
        super.tearDown()
    }

    func testMoviesInit_NotNil() {
        let movie = PersistenceController.sampleMovie
        XCTAssertNotNil(movie.id)
    }
    
    func testGetMovies() {
        let _ = PersistenceController.sampleMovies // 10 movies
        do {
            try persistenceController.container.viewContext.save()
        } catch  {
            print(error.localizedDescription)
        }
        
        XCTAssertEqual(numberOfMoviesInPersistentStore(), 10)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func clearData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let managedObjects = try! container.viewContext.fetch(fetchRequest)
        for case let managedObject as NSManagedObject in managedObjects {
            container.viewContext.delete(managedObject)
        }
        try! container.viewContext.save()
    }
    
    func numberOfMoviesInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let results = try! container.viewContext.fetch(request)
        return results.count
    }

}
