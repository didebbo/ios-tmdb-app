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
    
    func getImageDataFrom(imagePath: String, completion: @escaping (_ item: UnWrappedData<Data>) -> Void) {
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
    
    func getMovies(completion: @escaping (_ movies: UnWrappedData<[Item]>) -> Void) {
        
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
                        var items: [Item] = []
                        let globalGroup = DispatchGroup()
                        data.results.forEach { item in
                            globalGroup.enter()
                            
                            let localGroup = DispatchGroup()
                            
                            var posterImageData: Data?
                            var coverImageData: Data?
                            
                            if let poster_path = item.poster_path {
                                localGroup.enter()
                                getImageDataFrom(imagePath: poster_path) { item in
                                    posterImageData = item.result.data
                                    localGroup.leave()
                                }
                            }
                            if let backdrop_path = item.backdrop_path {
                                localGroup.enter()
                                getImageDataFrom(imagePath: backdrop_path) { item in
                                    coverImageData = item.result.data
                                    localGroup.leave()
                                }
                            }
                            
                            localGroup.notify(queue: .main) {
                                items.append(Item(id: item.id, title: item.title, description: item.overview, posterImageData: posterImageData, coverImageData: coverImageData, type: .movie))
                                globalGroup.leave()
                            }
                        }
                        globalGroup.notify(queue: .main) {
                            items.sort(by: {
                                let resultA = hasSavedMovie($0.id).result.data ?? false
                                let resultB = hasSavedMovie($1.id).result.data ?? false
                                return resultA && !resultB
                            })
                            completion(.success(items))
                        }
                    }
                }
            }
        }
    }
    
    func getSavedMovies() -> UnWrappedData<[Item]> {
        localDataManager.getSavedMovies()
    }
    
    func saveMovie(_ movie: Item) -> UnWrappedData<Bool>  {
        guard let _ = movie.id else { return .failure(DataProviderError.genericError(str: "On saveMovie, movie id is null")) }
        return localDataManager.saveMovie(movie)
    }
    
    func unSaveMovie(_ movie: Item) -> UnWrappedData<Item> {
        localDataManager.unSaveMovie(movie)
    }
    
    func hasSavedMovie(_ id: Int?) -> UnWrappedData<Bool> {
        guard let id else { return .failure(DataProviderError.genericError(str: "On hasSavedMovie, movie id is null")) }
        let savedMovieResult = getSavedMovies().result
        if let error = savedMovieResult.error {
            return .failure(error)
        }
        if let data = savedMovieResult.data {
            return .success(data.contains(where: { $0.id == id }))
        }
        return .failure(DataProviderError.genericError(str: "Unhandled error on hasSavedMovie"))
    }
}

// MARK: TV SHOWS
extension DataProvider {
    
    func getTvShows(completion: @escaping (_ shows: UnWrappedData<[Item]>) -> Void) {
        
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
                        var items: [Item] = []
                        let globalGroup = DispatchGroup()
                        
                        data.results.forEach { item in
                            globalGroup.enter()
                            
                            let localGroup = DispatchGroup()
                            
                            var posterImageData: Data?
                            var coverImageData: Data?
                            
                            if let poster_path = item.poster_path {
                                localGroup.enter()
                                getImageDataFrom(imagePath: poster_path) { itemResponse in
                                    posterImageData = itemResponse.result.data
                                    localGroup.leave()
                                }
                            }
                            
                            if let backdrop_path = item.backdrop_path {
                                localGroup.enter()
                                getImageDataFrom(imagePath: backdrop_path) { itemResponse in
                                    coverImageData = itemResponse.result.data
                                    localGroup.leave()
                                }
                            }
                            
                            localGroup.notify(queue: .main) {
                                items.append(Item(id: item.id, title: item.name, description: item.overview, posterImageData: posterImageData, coverImageData: coverImageData, type: .tvShow))
                                globalGroup.leave()
                            }
                        }
                        
                        globalGroup.notify(queue: .main) {
                            items.sort(by: {
                                let resultA = hasSavedTvShow($0.id).result.data ?? false
                                let resultB = hasSavedTvShow($1.id).result.data ?? false
                                return resultA && !resultB
                            })
                            completion(.success(items))
                        }
                    }
                }
            }
        }
    }
    
    func getSavedTvShows() -> UnWrappedData<[Item]> {
        localDataManager.getSavedTvShows()
    }
    
    func saveTvShow(_ tvShow: Item) -> UnWrappedData<Bool>  {
        guard let _ = tvShow.id else { return .failure(DataProviderError.genericError(str: "On saveTvShow, tvShow id is null")) }
        return localDataManager.saveTvShow(tvShow)
    }
    
    func unSaveTvShow(_ tvShow: Item) -> UnWrappedData<Item> {
        localDataManager.unSaveTvShow(tvShow)
    }
    
    func hasSavedTvShow(_ id: Int?) -> UnWrappedData<Bool> {
        guard let id else { return .failure(DataProviderError.genericError(str: "On hasSavedTvShow, tvShow id is null")) }
        let savedTvShowsResult = getSavedTvShows().result
        if let error = savedTvShowsResult.error {
            return .failure(error)
        }
        if let data = savedTvShowsResult.data {
            return .success(data.contains(where: { $0.id == id }))
        }
        return .failure(DataProviderError.genericError(str: "Unhandled error on hasSavedTvShow"))
    }
}

// MARK: ITEM DATA INFO
extension DataProvider {
    
    func getItemDataInfo(from item: Item) -> UnWrappedData<ItemDataInfo> {
        guard let itemId = item.id else { return .failure(DataProviderError.genericError(str: "On getItemDataInfo item id is null"))}
        let getItemDataInfoResult = localDataManager.getItemDataInfo(from: itemId, where: item.type).result
        if let error = getItemDataInfoResult.error {
            return .failure(error)
        }
        if let data: ItemDataInfo = getItemDataInfoResult.data ?? nil {
            return .success(data)
        }
        let saved: UnWrappedData<Bool> = {
            switch item.type {
            case .movie: hasSavedMovie(itemId)
            case .tvShow: hasSavedTvShow(itemId)
            }
        }()
        if let error = saved.result.error {
            return .failure(error)
        }
        if let saved = saved.result.data {
            return .success(ItemDataInfo(id: itemId, type: item.type, saved: saved))
        }
        return .failure(DataProviderError.genericError(str: "Unhandled error on getItemDataInfo"))
    }
    
    func saveItemDataInfo(_ itemDataInfo: ItemDataInfo) -> UnWrappedData<ItemDataInfo> {
        localDataManager.saveItemDataInfo(itemDataInfo)
    }
    
    func clearAllData() {
        localDataManager.clearAllData()
    }
}
