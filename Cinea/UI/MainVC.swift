//
//  MainVC.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import UIKit
import Kingfisher

class MainVC:UIViewController{
    
    @IBOutlet weak var popularMoviesCollection: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    weak var footerView:PopularMoviesFooter?
    
    var pendingPagination = false
    
    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = MovieService.popularMovies!.results
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        popularMoviesCollection.reloadData()
    }
    
    @IBAction func searchClick(_ sender: Any) {
        searchField.isHidden.toggle()
        if(!searchField.isHidden){
            searchField.becomeFirstResponder()
        }else{
            searchField.resignFirstResponder()
            searchField.text = ""
            searchFieldChanged(sender)
        }
    }
    
    @IBAction func searchFieldDoneAction(_ sender: Any) {
        searchField.resignFirstResponder()
        if(!searchField.hasText){
            searchField.isHidden = true
        }
    }
    
    @IBAction func searchFieldChanged(_ sender: Any) {
        if(searchField.hasText){
            movies = MovieService.popularMovies!.results.filter{$0.title.lowercased().contains(searchField.text!.lowercased())}
            popularMoviesCollection.setContentOffset(CGPoint(x:0,y:-50), animated: true)
        }else{
            movies = MovieService.popularMovies!.results
        }
        popularMoviesCollection.reloadData()
        footerView?.indicator.isHidden = searchField.hasText
    }
}

extension MainVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: (width-24)/2, height: width*7/8)
    }
}

extension MainVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(!searchField.hasText && !pendingPagination && indexPath.row > MovieService.popularMovies!.results.count-10){
            pendingPagination = true
            MovieService.getPopularMovies(callback: {result in
                self.pendingPagination = false
                DispatchQueue.main.asyncAfter(deadline: .now() + (result ? 0 : 1), execute: {
                    self.pendingPagination = false
                    if(!self.searchField.hasText){
                        self.movies = MovieService.popularMovies!.results
                        self.popularMoviesCollection.reloadData()
                    }
                })
            })
        }
        let movie = movies[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell {
            cell.title.text = movie.title
            if(movie.poster_path != nil){
                cell.image.kf.setImage(with: URL(string: MovieService.PosterURL + "w200" +  movie.poster_path!))
            }
            cell.addTapGestureRecognizer(action: {
                let movieDetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
                movieDetail.movie = movie
                self.navigationController?.pushViewController(movieDetail, animated: true)
            })
            cell.favIcon.isHidden = !Favourites.isFav(id: movie.id)
            if(searchField.hasText){
                cell.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    cell.alpha = 1
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "popularMoviesFooter", for: indexPath) as? PopularMoviesFooter
            footerView?.indicator.isHidden = searchField.hasText
            return footerView!
        }else if(kind == UICollectionView.elementKindSectionHeader){
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "popularMoviesHeader", for: indexPath)
            return headerView
        }
        return UICollectionReusableView()
    }
}

class PopularMoviesCell:UICollectionViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favIcon: UIImageView!
}

class PopularMoviesFooter:UICollectionReusableView{
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}
