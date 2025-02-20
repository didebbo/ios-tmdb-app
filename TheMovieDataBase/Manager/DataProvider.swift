//
//  DataProvider.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

// MARK: BASE STRUCT
struct DataProvider {
    
    static let shared: DataProvider = DataProvider()
    
    private let remoteDataProvider: RemoteDataProvider = RemoteDataProvider()
    private let tmdbManager: TMDBManager = TMDBManager(ACCESS_TOKEN: Env.TMDB_ACCESS_TOKEN)
    private let localDataManager: LocalDataManager = LocalDataManager()
    
    enum DataProviderError: ApplicationError {
        case genericError(str: String)
        
        var prefix: String { "[DataProvider]" }
        
        var message: String {
            switch self {
            case .genericError(let str):
                str
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
}

// MARK: MOVIES
extension DataProvider {
    
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
                            return Item(id: item.id, title: item.title, description: item.overview, posterPath: item.poster_path, coverPath: item.backdrop_path, saved: hasSavedMovie(item.id).result.data)
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
    
    func saveMovie(_ movie: Item) -> UnWrappedResult<Item>  {
        guard let _ = movie.id else { return .failure(DataProviderError.genericError(str: "On saveMovie, movie id is null")) }
        return localDataManager.saveMovie(movie)
    }
    
    func unSaveMovie(_ movie: Item) -> UnWrappedResult<Item> {
        localDataManager.unSaveMovie(movie)
    }
    
    func hasSavedMovie(_ id: Int?) -> UnWrappedResult<Bool> {
        guard let id else { return .failure(DataProviderError.genericError(str: "On hasSavedMovie, movie id is null")) }
        let savedMovieResult = localDataManager.getSavedMovies().result
        if let error = savedMovieResult.error {
            return .failure(error)
        }
        if let data = savedMovieResult.data {
            return .success(data.contains(where: { $0.id == id }))
        }
        return .failure(DataProviderError.genericError(str: "Unhandled error on hasSavedMovie"))
    }
}

// MARK TV SHOWS
extension DataProvider {
    
    func getTvShows(completion: @escaping (_ movies: UnWrappedResult<[Item]>) -> Void) {
        
        let urlString = tmdbManager.getUrlString(from: .discoverTv)
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
                    let decodedJsonResult = remoteDataProvider.getDecodedJson(from: data, to: TVShowsResponse.self).result
                    if let error = decodedJsonResult.error {
                        completion(.failure(error))
                    }
                    if let data = decodedJsonResult.data {
                        let items: [Item] = data.results.map { item in
                            return Item(id: item.id, title: item.name, description: item.overview, posterPath: item.poster_path, coverPath: item.backdrop_path, saved: hasSavedTvShow(item.id).result.data)
                        }
                        completion(.success(items))
                    }
                }
            }
        }
    }
    
    func saveTvShow(_ tvShow: Item) -> UnWrappedResult<Item>  {
        guard let _ = tvShow.id else { return .failure(DataProviderError.genericError(str: "On saveTvShow, tvShow id is null")) }
        return localDataManager.saveTvShow(tvShow)
    }
    
    func unSaveTvShow(_ tvShow: Item) -> UnWrappedResult<Item> {
        localDataManager.unSaveTvShow(tvShow)
    }
    
    func hasSavedTvShow(_ id: Int?) -> UnWrappedResult<Bool> {
        guard let id else { return .failure(DataProviderError.genericError(str: "On hasSavedTvShow, tvShow id is null")) }
        let savedTvShowsResult = localDataManager.getSavedTvShows().result
        if let error = savedTvShowsResult.error {
            return .failure(error)
        }
        if let data = savedTvShowsResult.data {
            return .success(data.contains(where: { $0.id == id }))
        }
        return .failure(DataProviderError.genericError(str: "Unhandled error on hasSavedTvShow"))
    }
}
