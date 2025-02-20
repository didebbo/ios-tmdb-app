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
        let urlResult = remoteDataProvider.getUrl(from: urlString).result
        if let error = urlResult.error {
            completion(.failure(error))
        }
        if let data = urlResult.data {
            let request = tmdbManager.getRequest(from: data)
            remoteDataProvider.fetchData(from: request) { response in
                let responseResult = response.result
                if let error = responseResult.error {
                    completion(.failure(error))
                }
                if let data = responseResult.data {
                    let decodedJsonResult = remoteDataProvider.getDecodedJson(from: data, to: MovieResponse.self).result
                    if let error = decodedJsonResult.error {
                        completion(.failure(error))
                    }
                    if let data = decodedJsonResult.data {
                        let items: [Item] = data.results.map { item in
                            Item(id: item.id, title: item.title, description: item.overview, posterPath: item.poster_path, coverPath: item.backdrop_path, saved: hasSavedMovie(item.id))
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
    
    func getTVShows(completion: @escaping (_ tvShows: UnWrappedResult<[Item]>) -> Void) {
        let urlResult = remoteDataProvider.getUrl(from: tmdbManager.getUrlString(from: .discoverTv)).result
        if let error = urlResult.error {
            completion(.failure(error))
        }
        if let data = urlResult.data {
            let request = tmdbManager.getRequest(from: data)
            remoteDataProvider.fetchData(from: request) { response in
                let responseResult = response.result
                if let error = responseResult.error {
                    completion(.failure(error))
                }
                if let data = responseResult.data {
                    let decodedJsonResult = remoteDataProvider.getDecodedJson(from: data, to: TVShowsResponse.self).result
                    if let error = decodedJsonResult.error {
                        completion(.failure(error))
                    }
                    if let data = decodedJsonResult.data {
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
        let urlResult = remoteDataProvider.getUrl(from: imageUrlString).result
        if let data = urlResult.data {
            remoteDataProvider.fetchData(from: URLRequest(url: data)) { response in
                let responseResult = response.result
                if let data = responseResult.data {
                    completion(.success(data))
                }
            }
        }
    }
    
    func saveMovie(_ movie: Item) -> UnWrappedResult<Item>  {
        localDataManager.saveMovie(movie)
    }
    
    func hasSavedMovie(_ id: Int?) -> Bool {
        var result = false
        guard let id else { return result }
        localDataManager.getSavedMovies().hasData { data in
            result = data.contains(where: { $0.id == id })
        }
        return result
    }
}
