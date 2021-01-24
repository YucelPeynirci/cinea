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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
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
        let movie = MovieService.popularMovies?.results[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCell", for: indexPath) as? PopularMoviesCell {
            cell.title.text = movie?.title
            if(movie?.poster_path != nil){
                cell.image.kf.setImage(with: URL(string: MovieService.PosterURL + "w200" +  movie!.poster_path!))
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
