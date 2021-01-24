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
    
    var pendingPagination = false
    
}

extension MainVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: (width-10)/2, height: width*7/8)
    }
}

extension MainVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MovieService.popularMovies?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(!pendingPagination && indexPath.row > MovieService.popularMovies!.results.count-10){
            pendingPagination = true
            MovieService.getPopularMovies(callback: {result in
                DispatchQueue.main.async {
                    self.pendingPagination = false
                    self.popularMoviesCollection.reloadData()
                }
            })
        }
        let movie = MovieService.popularMovies!.results[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell {
            cell.title.text = movie.title
            if(movie.poster_path != nil){
                cell.image.kf.setImage(with: URL(string: MovieService.PosterURL + "w200" +  movie.poster_path!))
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

class PopularMoviesCell:UICollectionViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
}
