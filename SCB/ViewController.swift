//
//  ViewController.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let footerViewReuseIdentifier = "loadingresuableview"
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet var searchBarForMovie: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var arrayForMovieList = [Movie]()
    var  moviePresenter = MovieListPresenter(networkService: NetworkService())
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    var isLoading = false
    var footerView:CustomFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        movieCollectionView?.collectionViewLayout = columnLayout
        movieCollectionView?.contentInsetAdjustmentBehavior = .always
        moviePresenter.attachView(true, view: self)
        searchBarForMovie.barTintColor = UIColor(red: 46.0/255.0, green: 14.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
        if let textfield = searchBarForMovie.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
        }
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        movieCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayForMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieListCustomCell ?? MovieListCustomCell()
        let movie = arrayForMovieList[indexPath.item]
        cell.labelForTitle.text = movie.title
        let imageURL = URL(string: movie.poster ?? "")
        if let posterUrl = imageURL {
            cell.imageForPoster.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.imageForPoster.sd_imageIndicator?.startAnimatingIndicator()
            cell.imageForPoster.sd_setImage(with: posterUrl) {[weak self] (image, err, type, url) in
                if err != nil {
                    cell.imageForPoster.image = UIImage(named: "placeholder")
                }
                else {
                    cell.imageForPoster.image = image
                }
                cell.imageForPoster.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = arrayForMovieList[indexPath.item]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let movieDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailViewController.selectedMovieID = movie.imdbID
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 && arrayForMovieList.count != Int(moviePresenter.totalResult) ?? 0 {
            self.footerView?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0 && arrayForMovieList.count != Int(moviePresenter.totalResult) ?? 0
        {
            guard let footerView = self.footerView, footerView.isAnimatingFinal else { return }
            print("load more trigger")
            self.isLoading = true
            self.footerView?.startAnimate()
            moviePresenter.getMovieList(searchMovie: searchBarForMovie.text ?? "", isFetchedFromScrolling: true)
            
        }
    }
}

extension ViewController: MovieListView{
    
    func showMessage(message: String) {
        
        DispatchQueue.main.async { [weak self] () -> Void in
            let controller = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    func addMovieInList(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.arrayForMovieList += movies
            self.movieCollectionView.reloadData()
            self.isLoading = false
        }
    }
    
    func startLoading() {
        spinner.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func setEmpty() {
        self.arrayForMovieList = []
    }
}



extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isLoading = false
        searchBar.resignFirstResponder()
        if searchBar.text == nil || searchBar.text == "" {
            self.showMessage(message: emptySearchStringError)
        }
        else {
            moviePresenter.pageNumber = 1
            moviePresenter.searchString = ""
            arrayForMovieList.removeAll()
            movieCollectionView.reloadData()
            moviePresenter.searchString = searchBar.text ?? ""
            moviePresenter.getMovieList(searchMovie: searchBar.text ?? "", isFetchedFromScrolling: false )
        }
    }
}

