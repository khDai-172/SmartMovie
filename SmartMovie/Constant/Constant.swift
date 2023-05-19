//
//  ServerConstant.swift
//  SmartMovie
//
//  Created by Khoa Dai on 31/03/2023.
//

import Foundation

struct Constant: Codable {
    static let APIKey = "d5b97a6fad46348136d87b78895a0c06"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let timeOutInterval: Double = 40.0
    static let castPath = "IwAR0OJxzZPhqyF-fyRocXTKf4rjL8kA2sPXki9OMYtt4qdxxZqXYkCrNj8VI"
    static var isViewChanged: Bool = false

    struct TypePath: Codable {
        static let popular = "popular"
        static let topRated = "top_rated"
        static let upComing = "upcoming"
        static let nowPlaying = "now_playing"
        static let credits = "credits"
    }
}
