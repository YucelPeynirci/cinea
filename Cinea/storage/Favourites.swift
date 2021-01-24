//
//  Storage.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import Foundation

class Favourites{
    static private let FavouriteMoviesKey = "FavouriteMovies"
    static private var favouriteMovies:[Int] = Favourites.getFavouriteMovies()
    
    static func isFav(id:Int) -> Bool{
        return favouriteMovies.contains(id)
    }
    
    static func toggleFav(id:Int){
        if(isFav(id: id)){
            favouriteMovies = favouriteMovies.filter{$0 != id}
        }else{
            favouriteMovies.append(id)
        }
        saveFavouriteMovies()
    }
    
    static private func getFavouriteMovies()->[Int]{
        return UserDefaults.standard.array(forKey: FavouriteMoviesKey)  as? [Int] ?? [Int]()
    }
    
    static private func saveFavouriteMovies(){
        UserDefaults.standard.set(favouriteMovies, forKey: FavouriteMoviesKey)
        UserDefaults.standard.synchronize()
    }
}
