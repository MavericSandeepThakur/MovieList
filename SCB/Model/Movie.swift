//
//  Movie.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import Foundation
struct Movie: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        imdbID = try values.decode(String.self, forKey: .imdbID)
        type = try values.decode(String.self, forKey: .type)
        poster = try values.decode(String.self, forKey: .poster)
    }
    
    init(title: String, year: String, imdbID: String, type: String, poster: String?) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.type = type
        self.poster = poster
    }
}

struct MovieList: Decodable {
    let movieList: [Movie]?
    let totalResult: String?
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case movieList = "Search"
        case totalResult = "totalResults"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        movieList = try? values.decode([Movie].self, forKey: .movieList)
        totalResult = try? values.decode(String.self, forKey: .totalResult)
        response = try values.decode(String.self, forKey: .response)
    }
    
    init(movieList: [Movie], totalResult: String, response: String) {
        self.movieList = movieList
        self.totalResult = totalResult
        self.response = response
    }
}
