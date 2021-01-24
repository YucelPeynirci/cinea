//
//  MovieDetails.swift
//  Cinea
//
//  Created by Yücel Peynirci on 24.01.2021.
//

struct MovieDetails: Codable {
    let adult: Bool
    let belongs_to_collection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let id: Int
    let original_language, original_title: String
    let popularity: Double
    let poster_path, overview, imdb_id, homepage, backdrop_path: String?
    let production_companies: [ProductionCompany]
    let production_countries: [ProductionCountry]
    let release_date: String
    let revenue: Int
    let spoken_languages: [SpokenLanguage]
    let status, title: String
    let tagline:String?
    let runtime:Int?
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}

struct BelongsToCollection: Codable {
    let id: Int
    let name: String
    let poster_path, backdrop_path: String?
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable {
    let id: Int
    let logo_path: String?
    let name, origin_country: String
}

struct ProductionCountry: Codable {
    let iso3166_1, name: String
}

struct SpokenLanguage: Codable {
    let english_name, iso639_1, name: String
}
