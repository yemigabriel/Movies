////
////  Movie.swift
////  Movies
////
////  Created by Yemi Gabriel on 2/12/22.
////
//
//import Foundation
//
//struct Movie {
//    let movieId: Int
//    let title: String
//    let summary: String
//    let poster: String
//    let releaseDate: Date
//    let popularity: Double?
//    let runtime: Int?
//    let genres: [Genre]?
//    let credits: [Credit]?
//    var category: String = MovieCategory.latest.rawValue
//    
//    enum CodingKeys: String, CodingKey {
//        case movieId = "id"
//        case title
//        case summary = "overview"
//        case poster = "poster_path"
//        case runtime
//        case releaseDate = "release_date"
//        case popularity = "popularity"
//        case genres = "genres"
//        case credits
//    }
//}
//
//extension Movie: Decodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        movieId = try container.decode(Int.self, forKey: .movieId)
//        title = try container.decode(String.self, forKey: .title)
//        summary = try container.decode(String.self, forKey: .summary)
//        poster = try container.decode(String.self, forKey: .poster)
//        
//        let date = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
//        releaseDate = date.toDate()
//        
//        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
//        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
//        genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
//        credits = try container.decodeIfPresent([Credit].self, forKey: .credits)
//    }
//}
