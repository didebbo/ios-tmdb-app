//
//  Response.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
    
    struct Movie: Codable {
        let id: Int
        let title: String
        let overview: String
        let backdrop_path: String
        let poster_path: String
    }
}
