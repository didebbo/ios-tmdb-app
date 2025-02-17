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
    
    func getMovies(completion: @escaping (_ item: SafeResult<[Item]>) -> Void) {
        if let url = tmdb.getUrl(from: .discoverMovie) {
            let request = tmdb.getRequest(from: url)
            tmdb.getResponse(from: request) { response in
                let result = getDecodedJson(from: response.jsonData, to: MovieResponse.self)
                result.hasError { error in
                    completion(.failure(error))
                }
                result.hasData { r in
                    let items: [Item] = r.results.map { movie in
                        let imageurl = tmdb.getImageUrl(from: movie.poster_path)
                        let detailImage = tmdb.getImageUrl(from: movie.backdrop_path)
                        return Item(id: movie.id, title: movie.title, description: movie.overview, posterUrl: imageurl, coverUrl: detailImage)
                    }
                    completion(.success(items))
                }
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
