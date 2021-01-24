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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottom: NSLayoutConstraint!
    @IBOutlet weak var darkgroundTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.kf.setImage(with: URL(string: MovieService.PosterURL + "w200" +  movie!.poster_path!), placeholder: nil, options: nil, completionHandler: {result in
            self.image.kf.setImage(with: URL(string: MovieService.PosterURL + "w300" + self.movie!.poster_path!),placeholder: self.image.image)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.descriptionBottom.constant = scrollView.frame.size.height/3
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        imageTop.constant = -offset/2
        darkgroundTop.constant = imageTop.constant
        if(offset > 0){
            image.alpha = 1-(offset/scrollView.frame.size.height)
        }
    }
    
}
