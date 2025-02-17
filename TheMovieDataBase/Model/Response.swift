//
//  Response.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

enum SafeResult<R> {
    case success(R)
    case failure(Error)
}

struct Response {
    var statusCode: Int?
    var error: Error?
    var jsonData: Data?
}

struct MovieResponse: Codable {
    let results: [Movie]
    
    struct Movie: Codable {
        let title: String
        let overview: String
        let backdrop_path: String
        let poster_path: String
    }
}
