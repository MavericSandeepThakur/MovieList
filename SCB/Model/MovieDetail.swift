//
//  MovieDetail.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import Foundation
struct MovieDetail: Decodable {
    let title: String
    let year: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let runTime: String
    let imdbRating: String
    let score: String
    let imdbVotes: String
    let poster: String
    let response: String
    
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case runTime = "Runtime"
        case imdbRating = "imdbRating"
        case score = "Metascore"
        case imdbVotes = "imdbVotes"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        genre = try values.decode(String.self, forKey: .genre)
        director = try values.decode(String.self, forKey: .director)
        writer = try values.decode(String.self, forKey: .writer)
        actors = try values.decode(String.self, forKey: .actors)
        plot = try values.decode(String.self, forKey: .plot)
        runTime = try values.decode(String.self, forKey: .runTime)
        imdbRating = try values.decode(String.self, forKey: .imdbRating)
        score = try values.decode(String.self, forKey: .score)
        imdbVotes = try values.decode(String.self, forKey: .imdbVotes)
        poster = try values.decode(String.self, forKey: .poster)
        response = try values.decode(String.self, forKey: .response)
    }
    
}
