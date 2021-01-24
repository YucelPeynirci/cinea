//
//  MovieDetailVC.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import UIKit
import Kingfisher

class MovieDetailVC:UIViewController{
    var movie:Movie?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.kf.setImage(with: URL(string: MovieService.PosterURL + "w200" +  movie!.poster_path!), placeholder: nil, options: nil, completionHandler: {result in
            self.image.kf.setImage(with: URL(string: MovieService.PosterURL + "w300" + self.movie!.poster_path!),placeholder: self.image.image)
        })
        labelTitle.text = movie?.title
        labelDescription.text = movie?.overview
        MovieService.getMovieDetails(movie: movie!, callback: {result in
            self.labelDescription.text = result?.overview
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
