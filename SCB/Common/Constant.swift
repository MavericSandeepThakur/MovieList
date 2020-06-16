//
//  Constant.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import Foundation
let apiKey = "b9bd48a6"
let omdbBaseUrl = "http://www.omdbapi.com"
let type = "movie"
let emptySearchStringError = "Please Enter Movie Name"
let noMoreResultMessage = "No More Result"
let noMovieFoundError = "No Movie Found"
class Constants {
    
    static func getMovieListUrl(searchedMovie: String, pageNumber: Int) -> URL? {
        return  URL(string: String(format: "%@/?apikey=%@&s=%@&type=%@&page=%d", omdbBaseUrl,apiKey,searchedMovie,type,pageNumber))
    }
    
    static func getMovieDetail(selectedMovie: String) -> URL? {
        return  URL(string: String(format: "%@/?apikey=%@&i=%@", omdbBaseUrl,apiKey,selectedMovie))
    }
}
