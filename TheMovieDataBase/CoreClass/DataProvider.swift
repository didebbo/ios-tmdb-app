//
//  DataProvider.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct DataProvider {
    
    static let shared: DataProvider = DataProvider()
    
    private let tmdb: TMDB = TMDB(ACCESS_TOKEN: Env.TMDB_ACCESS_TOKEN)
    
    func getMovies() {
        if let url = tmdb.getUrl(from: .discoverMovie) {
            let request = tmdb.getRequest(from: url)
            tmdb.getResponse(from: request) { response in
                print(response)
            }
        }
    }
}
