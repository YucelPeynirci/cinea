//
//  ViewController.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MovieService.getPopularMovies(pageID: 1, callback: {result in
            print(result)
        })
    }


}

