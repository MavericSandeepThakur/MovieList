//
//  MovieDetail.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableForMovieDetail: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var movieDetail: MovieDetail?
    var selectedMovieID: String = ""
    var  movieDetailPresenter = MovieDetailPresenter(networkService: NetworkService())
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        self.title = "Movie Detail"
        movieDetailPresenter.attachView(true, view: self)
        tableForMovieDetail.isHidden = true
        movieDetailPresenter.getMovieDetail(selectedMovieID: selectedMovieID)
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieDetail", for: indexPath) as? MovieDetailCustomCell
        guard let detailCell = cell else { return UITableViewCell() }
        detailCell.labelForTitle.text = "\(movieDetail?.title ?? "")\n\(movieDetail?.year ?? "")"
        detailCell.labelForCategory.text = movieDetail?.genre
        detailCell.labelForDuration.text = movieDetail?.runTime
        detailCell.labelForRating.text = movieDetail?.imdbRating
        detailCell.labelForSynopsis.text = movieDetail?.plot
        detailCell.labelForScore.text = "Score\n\(movieDetail?.score ?? "")"
        detailCell.labelForReview.text = "Reviews\n\(movieDetail?.imdbVotes ?? "")"
        detailCell.labelForPopularity.text = "Popularity\n\(movieDetail?.imdbRating ?? "")"
        detailCell.labelForDirector.text = movieDetail?.director
        detailCell.labelForActor.text = movieDetail?.actors
        detailCell.labelForWriter.text = movieDetail?.writer
        let imageURL = URL(string: movieDetail?.poster ?? "")
        if let posterUrl = imageURL {
            detailCell.imageForPoster.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            detailCell.imageForPoster.sd_imageIndicator?.startAnimatingIndicator()
            detailCell.imageForPoster.sd_setImage(with: posterUrl) {[weak self] (image, err, type, url) in
                if err != nil {
                    detailCell.imageForPoster.image = UIImage(named: "placeholder")
                }
                else {
                    detailCell.imageForPoster.image = image
                }
                detailCell.imageForPoster.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
        return detailCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MovieDetailViewController: MovieDetailsView {
    func startLoading() {
        spinner.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.tableForMovieDetail.isHidden = false
            self.spinner.stopAnimating()
        }
    }
    
    func showMovieDetail(_ moviesDetailResponse: MovieDetail) {
        self.movieDetail = moviesDetailResponse
        DispatchQueue.main.async {
            self.tableForMovieDetail.reloadData()
               }
        
    }
    
    
}
