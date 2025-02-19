//
//  DataProvider.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct DataProvider {
    
    static let shared: DataProvider = DataProvider()
    
    private let remoteDataProvider: RemoteDataProvider = RemoteDataProvider()
    private let tmdbManager: TMDBManager = TMDBManager(ACCESS_TOKEN: Env.TMDB_ACCESS_TOKEN)
    private let localDataManager: LocalDataManager = LocalDataManager()
    
    func getMovies(completion: @escaping (_ movies: UnWrappedResult<[Item]>) -> Void) {
        
        let urlString = tmdbManager.getUrlString(from: .discoverMovie)
        let url = remoteDataProvider.getUrl(from: urlString)
        url.hasError { error in
            completion(.failure(error))
        }
        url.hasData { url in
            let request = tmdbManager.getRequest(from: url)
            remoteDataProvider.fetchData(from: request) { response in
                response.hasError { error in
                    completion(.failure(error))
                }
                response.hasData { data in
                    let decodedJson = remoteDataProvider.getDecodedJson(from: data, to: MovieResponse.self)
                    decodedJson.hasError { error in
                        completion(.failure(error))
                    }
                    decodedJson.hasData { data in
                        let items: [Item] = data.results.map { item in
                            Item(id: item.id, title: item.title, description: item.overview, posterPath: item.poster_path, coverPath: item.backdrop_path)
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
    
    func getTVShows(completion: @escaping (_ tvShows: UnWrappedResult<[Item]>) -> Void) {
        let url = remoteDataProvider.getUrl(from: tmdbManager.getUrlString(from: .discoverTv))
        url.hasError { error in
            completion(.failure(error))
        } 
        url.hasData { url in
            let request = tmdbManager.getRequest(from: url)
            remoteDataProvider.fetchData(from: request) { response in
                response.hasError { error in
                    completion(.failure(error))
                }
                response.hasData { data in
                    let decodedJson = remoteDataProvider.getDecodedJson(from: data, to: TVShowsResponse.self)
                    decodedJson.hasError { error in
                        completion(.failure(error))
                    }
                    decodedJson.hasData { data in
                        let items = data.results.map { item in
                            Item(id: item.id, title: item.name, description: item.overview, posterPath: item.poster_path, coverPath: item.backdrop_path)
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
    
    func getImageDataFrom(imagePath: String, completion: @escaping (_ item: UnWrappedResult<Data>) -> Void) {
        let imageUrlString = tmdbManager.getImageUrlStringFrom(imagePath: imagePath)
        let url = remoteDataProvider.getUrl(from: imageUrlString)
        url.hasData { url in
            remoteDataProvider.fetchData(from: URLRequest(url: url)) { response in
                response.hasData { data in
                    completion(.success(data))
                }
            }
        }
    }
}
