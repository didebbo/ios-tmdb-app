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
        let url = tmdb.getUrl(from: .discoverMovie)
        url.hasError { error in
            completion(.failure(error))
        }
        url.hasData { data in
            let request = tmdb.getRequest(from: data)
            tmdb.getResponse(from: request) { data in
                data.hasError { error in
                    completion(.failure(error))
                }
                data.hasData { data in
                    let result = getDecodedJson(from: data, to: MovieResponse.self)
                    result.hasError { error in
                        completion(.failure(error))
                    }
                    result.hasData { r in
                        let items: [Item] = r.results.map { movie in
                            var item = Item(id: movie.id, title: movie.title, description: movie.overview)
                            tmdb.getImageUrl(from: movie.poster_path).hasData { data in
                                item.posterUrl = data
                            }
                            tmdb.getImageUrl(from: movie.backdrop_path).hasData { data in
                                item.coverUrl = data
                            }
                            return item
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
}

extension DataProvider {
    
    private func getDecodedJson<M: Codable>(from data: Data, to model: M.Type) -> SafeResult<M> {
        do {
            let decodedJson = try JSONDecoder().decode(model, from: data)
            return SafeResult.success(decodedJson)
        } catch {
            return .failure(.genericError(error.localizedDescription))
        }
    }
    
}
