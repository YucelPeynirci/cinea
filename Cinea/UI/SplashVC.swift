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
        getPopularMovies()
    }
    
    func getPopularMovies(){
        MovieService.getPopularMovies(callback: {result in
            if(result){
                DispatchQueue.main.async {
                    self.goToMainVC()
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                    self.getPopularMovies()
                })
            }
        })
    }
    
    func goToMainVC(){
        let mainNavigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigation")
        mainNavigation.modalPresentationStyle = .fullScreen
        mainNavigation.modalTransitionStyle = .flipHorizontal
        self.present(mainNavigation, animated: true, completion: nil)
    }
}
