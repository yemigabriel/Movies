//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/9/22.
//

import Foundation
import Combine

class MovieListVM: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var selectedMovie: Movie?
    @Published var category: MovieCategory = .latest
    @Published var hasNetworkError: Bool = false
    var cancellable: AnyCancellable?
    
    init(movies: AnyPublisher<[Movie], Never> = CoreDataHelper.shared.movies.eraseToAnyPublisher()) {
        cancellable = movies.sink(receiveValue: { [weak self] movies in
            self?.movies = movies.filter({$0.category == self?.category.rawValue})
        })
    }
    
    func getLocalMovies() {
        let filtered = movies.filter({$0.category == category.rawValue})
        if filtered.isEmpty {
            fetchMovies()
        }
        CoreDataHelper.shared.getMovies(category: category)
    }
    
    func fetchMovies() {
        APIService.shared.fetchMovies(category: self.category)
    }
    
    func fetchMovieDetails() {
        if selectedMovie?.runtime == 0 {
            APIService.shared.fetchMovie(movie: selectedMovie)
            cancellable = CoreDataHelper.shared.selectedMovie.sink(receiveValue: { [weak self] movie in
                self?.selectedMovie = movie
            })
        }
    }
    
    func fetchMovieCast() {
        if selectedMovie?.credits?.count == 0 {
            APIService.shared.fetchMovieCast(movie: selectedMovie)
            cancellable = CoreDataHelper.shared.selectedMovie.sink(receiveValue: { [weak self] movie in
                self?.selectedMovie = movie
            })
        }
    }
    
    func getCast() -> [Cast]? {
        guard let selectedMovie = selectedMovie else { return nil}
        guard let credits = selectedMovie.credits?.allObjects as? [Credit] else { return nil }
        guard let cast = credits.first?.cast?.allObjects as? [Cast] else { return nil }
        return cast.filter({$0.profile != nil})
    }
}

enum MovieCategory: String, CaseIterable {
    case latest = "Latest"
    case popular = "Popular"
    case upcoming = "Upcoming"
}
