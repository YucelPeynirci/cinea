//
//  MovieDetailVC.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import UIKit
import Kingfisher

class MovieDetailVC:UIViewController,UIScrollViewDelegate{
    var movie:Movie?
    @IBOutlet weak var darkground: UIView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottom: NSLayoutConstraint!
    @IBOutlet weak var darkgroundTop: NSLayoutConstraint!
    @IBOutlet weak var favBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poster.kf.setImage(with: URL(string: MovieService.PosterURL + "w200" +  movie!.poster_path!), placeholder: nil, options: nil, completionHandler: {result in
            self.poster.kf.setImage(with: URL(string: MovieService.PosterURL + "w300" + self.movie!.poster_path!),placeholder: self.poster.image)
        })
        labelTitle.text = movie?.title
        labelDescription.text = movie?.overview
        MovieService.getMovieDetails(movie: movie!, callback: {result in
            DispatchQueue.main.async {
                self.labelDescription.text = result?.overview
            }
        })
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = movie?.title
        self.navigationController?.isNavigationBarHidden = false
        updateFav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.descriptionBottom.constant = scrollView.frame.size.height/3
    }
    
    @IBAction func favClick(_ sender: Any) {
        Favourites.toggleFav(id: movie!.id)
        updateFav()
    }
    
    func updateFav(){
        if(Favourites.isFav(id: movie!.id)){
            favBtn.image = #imageLiteral(resourceName: "starFilled")
        }else{
            favBtn.image = #imageLiteral(resourceName: "starEmpty")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        imageTop.constant = -offset/2
        darkgroundTop.constant = imageTop.constant
        if(offset > 0){
            poster.alpha = 1-(offset/scrollView.frame.size.height)
        }
    }
    
}
