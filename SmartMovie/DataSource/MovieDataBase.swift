//  MovieResponseEntity.swift
//  SmartMovie
//  Created by Khoa Dai on 31/03/2023.

import Foundation

struct MovieDataBase: Codable {
    let page: Int?
    let results: [MovieEntity]
}

struct MovieEntity: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreId: [Int]?
    let genres: [Genre]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCountry: [ProductionCountry]?
    let releaseDate: String?
    let title: String?
    let runtime: Int?
    let spokenLanguage: [SpokenLanguage]?
    let voteAverage: Double?
    let voteCount: Int?
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreId = "genre_ids"
        case genres
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCountry = "production_countries"
        case releaseDate = "release_date"
        case title
        case runtime
        case spokenLanguage = "spoken_languages"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieGenre: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct ProductionCountry: Codable {
    let iso31661: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let languageName: String?
    let iso6391: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case languageName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}

struct Credits: Codable {
    let cast: [Cast]?
}

struct Cast: Codable {
    let name: String?
    let originalName: String?
    let profilePath: String?
    enum CodingKeys: String, CodingKey {
        case name
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
}
