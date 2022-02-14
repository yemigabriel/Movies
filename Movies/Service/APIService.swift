//
//  APIService.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/9/22.
//

import Foundation
import Combine
import CoreData
import Network

class APIService {
    static let shared = APIService()
    var cancellable: AnyCancellable?
    let coreDataHelper = CoreDataHelper.shared
    let backgroundContext: NSManagedObjectContext
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[.context!] = backgroundContext
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init() {
        backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func fetchMovies(category: MovieCategory) {
        let categoryKey = CodingUserInfoKey(rawValue: category.rawValue)
        decoder.userInfo[categoryKey!] = category
        
        var path = ""
        switch category {
        case .latest:
            path = EndPoints.latest.fullPath
        case .popular:
            path = EndPoints.popular.fullPath
        case .upcoming:
            path = EndPoints.upcoming.fullPath
        }
        
        guard let url = URL(string: path) else { return }
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: Response.self, decoder: decoder)
            .sink(receiveCompletion: { print("\($0).") },
                  receiveValue: { [weak self] data in
                do {
                    try self?.backgroundContext.save()
                } catch {
                    print(error)
                }
            })
    }
    
    func fetchMovie(movie: Movie?) {
        guard let movie = movie else { return }
        let categoryKey = CodingUserInfoKey(rawValue: movie.category!)
        if let category = movie.category {
            decoder.userInfo[categoryKey!] = MovieCategory(rawValue: category)
        }
        
        let path = EndPoints.detail(movieId: Int(movie.movieId)).fullPath
        guard let url = URL(string: path) else { return }
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: Movie.self, decoder: decoder)
            .sink(receiveCompletion: {print("\($0).") },
                  receiveValue: { [weak self] movie in
                do {
                    try self?.backgroundContext.save()
                } catch {
                    print(error)
                }
            })
    }
    
    func fetchMovieCast(movie: Movie?) {
        guard let movie = movie else { return }
        
        let path = EndPoints.credits(movieId: Int(movie.movieId)).fullPath
        guard let url = URL(string: path) else { return }
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: Credit.self, decoder: decoder)
            .sink(receiveCompletion: {print("\($0).") },
                  receiveValue: { [weak self] credits in
                do {
                    movie.addToCredits(credits)
                    try self?.backgroundContext.save()
                } catch {
                    print(error)
                }
            })
    }
    
    
}

enum EndPoints {
    case latest
    case popular
    case upcoming
    case detail(movieId: Int)
    case credits(movieId: Int)
}

extension EndPoints {
    static let baseUrl = "https://api.themoviedb.org/3/movie"
    static let apiKey = "api_key=6e8a141e6ac45f1cc109be996558a94a"
    static let imgBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    var path: String {
        switch self{
        case .latest:
            return "/now_playing?page=1&"
        case .popular:
            return "/popular?page=1&"
        case .upcoming:
            return "/upcoming?page=1&"
        case .detail(movieId: let movieId):
            return "/\(movieId)?"
        case .credits(movieId: let movieId):
            return "/\(movieId)/credits?"
        }
    }
    
    var fullPath: String {
        switch self {
        case .latest:
            return "\(Self.baseUrl)\(path)\(Self.apiKey)"
        case .popular:
            return "\(Self.baseUrl)\(path)\(Self.apiKey)"
        case .upcoming:
            return "\(Self.baseUrl)\(path)\(Self.apiKey)"
        case .detail(let _):
            return "\(Self.baseUrl)\(path)\(Self.apiKey)"
        case .credits(let _):
            return "\(Self.baseUrl)\(path)\(Self.apiKey)"
        }
    }
}

enum APIErrors: Error {
    case networkError
}

struct Response: Decodable {
    let results: [Movie]
}
