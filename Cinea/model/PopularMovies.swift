//
//  PopularMovies.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

struct PopularMovies: Codable {
    var page: Int
    var results: [Movie]
    let total_pages, total_results: Int
}

struct Movie: Codable {
    let adult: Bool
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title, overview: String
    let popularity: Double
    let title: String
    let poster_path,backdrop_path,release_date: String?
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    var movie_details:MovieDetails?
}
