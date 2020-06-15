//
//  MovieDetailPresenter.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import Foundation
protocol MovieDetailsView: NSObjectProtocol {
    func startLoading()
    func stopLoading()
    func showMovieDetail(_ moviesDetail: MovieDetail)
}
class MovieDetailPresenter {
    fileprivate let networkService: NetworkService
    weak fileprivate var view: MovieDetailsView?
    init(networkService:NetworkService) {
        self.networkService = networkService
    }
    func attachView(_ attach:Bool, view: MovieDetailsView?)  {
        if attach {
            self.view = view
        }
        else {
            self.view = nil
        }
    }
    
    func getMovieDetail(selectedMovieID: String) {
        self.view?.startLoading()
        networkService.getMovieDetails(movieID: selectedMovieID) { [weak self] movieDetail in
            self?.view?.stopLoading()
            if movieDetail.response == "True" {
                self?.view?.showMovieDetail(movieDetail)
            }
        }
    }
}
