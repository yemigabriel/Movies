//
//  CoreDataHelper.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/9/22.
//

import Foundation
import CoreData
import Combine

protocol CoreDataHelperProtocol {
    func getMovies(category: MovieCategory)
    func getMovieDetails()
    func addCredits(to movie: Movie)
    func addGenre(to movie: Movie)
}

protocol SaveMovieProtocol {
    func saveContext()
}

class CoreDataHelper: NSObject {
    
    static let shared = CoreDataHelper()
    let container: NSPersistentContainer
    private(set) var movies = CurrentValueSubject<[Movie], Never>([])
    private(set) var selectedMovie = PassthroughSubject<Movie, Never>()
    private var fetchController: NSFetchedResultsController<Movie>?
    
    init(persistentContainer: NSPersistentContainer = PersistenceController.shared.container ) {
        container = persistentContainer
        super.init()
        
        let fetchRequest = Movie.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchController!.delegate = self
    }
}

extension CoreDataHelper: CoreDataHelperProtocol {
    func getMovies(category: MovieCategory) {
        if category == .popular {
            fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        } else {
            fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        }
        
        do {
            try fetchController?.performFetch()
        } catch  {
            print("Error fetching movies ", error.localizedDescription)
        }
    }
    
    func getMovieDetails() {
        
    }
    
    func addCredits(to movie: Movie) {
        
    }
    
    func addGenre(to movie: Movie) {
        
    }
}

extension CoreDataHelper: SaveMovieProtocol {
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Managed Object Context could not save \(error.localizedDescription)")
            }
        }
    }
    
}

extension CoreDataHelper: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let movies = controller.fetchedObjects as? [Movie] else { return }
        self.movies.value = movies
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            if let movie = anObject as? Movie {
                self.selectedMovie.send(movie)
            }
        case .insert, .delete, .move:
            break
        @unknown default:
            print("unknown")
            break
        }
        
    }
    
    
}

