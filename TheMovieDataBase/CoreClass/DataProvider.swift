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
                let result = getDecodedJson(from: response.jsonData, to: MovieResponse.self)
                print(result)
            }
        }
    }
}

extension DataProvider {
    
    private func getDecodedJson<M: Codable>(from jsonData: Data?, to model: M.Type) -> SafeResult<M> {
        guard let jsonData else { return SafeResult.failure(TMDB.TMDB_Error.nullData) }
        do {
            let decodedJson = try JSONDecoder().decode(model, from: jsonData)
            return SafeResult.success(decodedJson)
        } catch {
            return SafeResult.failure(error)
        }
    }
    
}
