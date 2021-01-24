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
    
    var pendingPagination = false
    
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
        }
    }
    
    @IBAction func searchFieldDoneAction(_ sender: Any) {
        searchField.resignFirstResponder()
    }
    
    @IBAction func searchFieldChanged(_ sender: Any) {
        
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
        MovieService.popularMovies?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(!pendingPagination && indexPath.row > MovieService.popularMovies!.results.count-10){
            pendingPagination = true
            MovieService.getPopularMovies(callback: {result in
                self.pendingPagination = false
                DispatchQueue.main.asyncAfter(deadline: .now() + (result ? 0 : 1), execute: {
                    self.pendingPagination = false
                    self.popularMoviesCollection.reloadData()
                })
            })
        }
        let movie = MovieService.popularMovies!.results[indexPath.row]
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
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "popularMoviesFooter", for: indexPath)
            return footerView
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
