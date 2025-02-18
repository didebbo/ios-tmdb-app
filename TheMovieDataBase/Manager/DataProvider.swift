//
//  DataProvider.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct DataProvider {
    
    static let shared: DataProvider = DataProvider()
    
    func getMovies(completion: @escaping (_ item: UnWrappedResult<[Item]>) -> Void) {
        
        let urlString = TMDBManager.shared.getUrlString(from: .discoverMovie)
        let url = RemoteDataProvider.getUrl(from: urlString)
        url.hasError { error in
            completion(.failure(error))
        }
        url.hasData { url in
            let request = TMDBManager.shared.getRequest(from: url)
            RemoteDataProvider.fetchData(from: request) { response in
                response.hasError { error in
                    completion(.failure(error))
                }
                response.hasData { data in
                    let decodedJson = RemoteDataProvider.getDecodedJson(from: data, to: MovieResponse.self)
                    decodedJson.hasError { error in
                        completion(.failure(error))
                    }
                    decodedJson.hasData { data in
                        let items: [Item] = data.results.map { movie in
                            var item = Item(id: movie.id, title: movie.title, description: movie.overview)
                            
                            let posterUrl = RemoteDataProvider.getUrl(from: TMDBManager.shared.getImageUrlString(from: movie.poster_path))
                            let coverUrl = RemoteDataProvider.getUrl(from: TMDBManager.shared.getImageUrlString(from: movie.backdrop_path))
                            
                            posterUrl.hasData { item.posterUrl = $0 }
                            coverUrl.hasData { item.coverUrl = $0 }
                            
                            return item
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
}
