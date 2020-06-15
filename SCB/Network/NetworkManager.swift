//
//  NetworkManager.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import Foundation
typealias MovieListResult = (MovieList) -> Void
typealias MovieDetailResult = (MovieDetail) -> Void
class NetworkService {
    let session = URLSession.shared
    
    func getMovieListResult(searchedMovie: String, pageNumber: Int, result: @escaping MovieListResult) {
        let url = Constants.getMovieListUrl(searchedMovie: searchedMovie, pageNumber: pageNumber)
        guard let movieListUrl = url else { return  }
        let dataTask = session.dataTask(with: movieListUrl) { (responseData, serverUrlResponse, error) in
            
            if error != nil || responseData == nil {
                print("clientError")
                return
            }
            guard let _ = serverUrlResponse as? HTTPURLResponse, (200...299).contains((serverUrlResponse as? HTTPURLResponse)?.statusCode ?? 0) else {
                print("Network Error")
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: responseData!, options: [])
                let decoderResult = try! JSONDecoder().decode(MovieList.self, from: responseData!)
                result(decoderResult)
            }
            catch {
                print("Wrong Format")
            }
            
        }
        dataTask.resume()
    }
    
    func getMovieDetails(movieID: String, result: @escaping MovieDetailResult) {
        let url = Constants.getMovieDetail(selectedMovie: movieID)
        guard let movieDetailUrl = url else { return  }
        let dataTask = session.dataTask(with: movieDetailUrl) { (responseData, serverUrlResponse, error) in
            
            if error != nil || responseData == nil {
                print("clientError")
                return
            }
            guard let _ = serverUrlResponse as? HTTPURLResponse, (200...299).contains((serverUrlResponse as? HTTPURLResponse)?.statusCode ?? 0) else {
                print("Network Error")
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: responseData!, options: [])
                let decoderResult = try! JSONDecoder().decode(MovieDetail.self, from: responseData!)
                result(decoderResult)
            }
            catch {
                print("Wrong Format")
            }
            
        }
        dataTask.resume()
    }
}
