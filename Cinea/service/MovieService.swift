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
    static let URLPopularMovies = BaseURL + "popular?language=[LANG]]&api_key=" + APIKey + "&page=[PAGE]"
    static let URLMovieDetails = BaseURL + "[ID]]?language=[LANG]]&api_key=" + APIKey
    
    static func getPopularMovies(pageID:Int,callback:@escaping ((PopularMovies?) -> Void)){
        let url = URLPopularMovies
            .replacingOccurrences(of: "[LANG]", with: Prefs.getSystemLanguage())
            .replacingOccurrences(of: "[PAGE]", with: String(pageID))
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            if(data != nil){
                do{
                    let result: PopularMovies = try JSONDecoder().decode(PopularMovies.self, from: data!)
                    callback(result)
                }catch let ex{
                    print(ex)
                    callback(nil)
                }
            }else{
                callback(nil)
                if(error != nil){
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    static func getMovieDetails(movie:Movie,callback:((MovieDetails?) -> Void)){
        let url = URLMovieDetails
            .replacingOccurrences(of: "[LANG]", with: Prefs.getSystemLanguage())
            .replacingOccurrences(of: "[ID]", with: String(movie.id))
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8))
            } else {
                print("no data")
            }
            if(error != nil){
                print(error)
            }
        }
        task.resume()
    }
}
