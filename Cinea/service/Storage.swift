//
//  Storage.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import Foundation

class Storage{
    static let FavouriteMoviesKey = "FavouriteMovies"
    static var favouriteMovies:[Int] = Storage.getFavouriteMovies()
    
    static func getFavouriteMovies()->[Int]{
        return UserDefaults.standard.array(forKey: FavouriteMoviesKey)  as? [Int] ?? [Int]()
    }
    
    static func saveFavouriteMovies(){
        UserDefaults.standard.set(favouriteMovies, forKey: FavouriteMoviesKey)
        UserDefaults.standard.synchronize()
    }
}
