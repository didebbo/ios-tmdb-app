//
//  TMDBManager.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct TMDBManager {
    
    private let ACCESS_TOKEN: String
    private let host: String = "https://api.themoviedb.org/3/"
    private let imageHost: String = "https://image.tmdb.org/t/p/w500"
    
    // static let shared: TMDBManager = TMDBManager(ACCESS_TOKEN: Env.TMDB_ACCESS_TOKEN)
    
    enum EndPoint: String {
        case discoverMovie = "discover/movie"
        case discoverTv = "discover/tv"
    }
    
    func getUrlString(from endpoint: EndPoint) -> String {
        "\(host)\(endpoint.rawValue)"
    }
    
    func getImageUrlStringFrom(imagePath: String) -> String {
        "\(imageHost)\(imagePath)"
    }
    
    func getRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    init(ACCESS_TOKEN: String) { self.ACCESS_TOKEN = ACCESS_TOKEN }
}
