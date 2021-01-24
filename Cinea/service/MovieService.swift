//
//  MovieService.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

import Foundation

class MovieService{
    static let BaseURL = "https://api.themoviedb.org/3/movie/"
    static let APIKey = "fd2b04342048fa2d5f728561866ad52a"
    static let PosterURL = "http://image.tmdb.org/t/p/"
    static let URLPopularMovies = BaseURL + "popular?language=[LANG]]&api_key=" + APIKey + "&page=[PAGE]"
    static let URLMovieDetails = BaseURL + "[ID]]?language=[LANG]]&api_key=" + APIKey
    
    static var popularMovies:PopularMovies?
    
    static func getPopularMovies(callback:@escaping((Bool) -> Void)){
        var pageID = 1
        if(MovieService.popularMovies != nil){
            pageID = MovieService.popularMovies!.page + 1
        }
        let url = URLPopularMovies
            .replacingOccurrences(of: "[LANG]", with: Prefs.getSystemLanguage())
            .replacingOccurrences(of: "[PAGE]", with: String(pageID))
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            if(data != nil){
                do{
                    let result: PopularMovies = try JSONDecoder().decode(PopularMovies.self, from: data!)
                    if(MovieService.popularMovies != nil){
                        MovieService.popularMovies!.results.append(contentsOf: result.results)
                        MovieService.popularMovies!.page = result.page
                    }else{
                        MovieService.popularMovies = result
                    }
                    callback(true)
                }catch let ex{
                    print(ex)
                    callback(false)
                }
            }else{
                callback(false)
                print(error?.localizedDescription ?? "no error description")
            }
        }.resume()
    }
    
    static func getMovieDetails(movie:Movie,callback:@escaping((MovieDetails?) -> Void)){
        let url = URLMovieDetails
            .replacingOccurrences(of: "[LANG]", with: Prefs.getSystemLanguage())
            .replacingOccurrences(of: "[ID]", with: String(movie.id))
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            if(data != nil){
                do{
                    let result: MovieDetails = try JSONDecoder().decode(MovieDetails.self, from: data!)
                    callback(result)
                }catch let ex{
                    print(ex)
                    callback(nil)
                }
            }else{
                callback(nil)
                print(error?.localizedDescription ?? "no error description")
            }
        }.resume()
    }
}
