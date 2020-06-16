//
//  MovieListPresenter.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import Foundation
protocol MovieListView: NSObjectProtocol {
    func startLoading()
    func stopLoading()
    func setEmpty()
    func addMovieInList(_ movies: [Movie])
    func showMessage(message:String)
}

class MovieListPresenter {
    fileprivate let networkService: NetworkService
    weak fileprivate var view: MovieListView?
    var pageNumber = 1
    var totalResult: String = ""
    var searchString = ""
    
    init(networkService:NetworkService) {
        self.networkService = networkService
    }
    
    func attachView(_ attach:Bool, view:MovieListView?)  {
        if attach {
            self.view = view
        }
        else {
            self.view = nil
        }
    }
    
    func getMovieList(searchMovie: String, isFetchedFromScrolling: Bool) {
        self.view?.startLoading()
        if isFetchedFromScrolling {
            pageNumber = pageNumber + 1
        }
        networkService.getMovieListResult(searchedMovie: searchString, pageNumber: pageNumber) { [weak self] movieResponse in
            self?.view?.stopLoading()
            if movieResponse.response == "True" {
                self?.totalResult = movieResponse.totalResult ?? ""
                self?.view?.addMovieInList(movieResponse.movieList ?? [])
            }
            else {
                if isFetchedFromScrolling {
                    self?.view?.showMessage(message: noMoreResultMessage)
                }
                else {
                    self?.view?.showMessage(message: noMovieFoundError)
                }
            }
           
        }
    }
}
