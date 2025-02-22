//
//  LocalDataManager.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 19/02/25.
//

import Foundation

// MARK: BASE STRUCT
struct LocalDataManager {
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    enum Key: String {
        case movies = "savedMovies"
        case tvShows = "savedTvShows"
        case itemDataInfo = "itemDataInfo"
    }
    
    enum LocalDataManagerError: ApplicationError {
        case genericError(str: String)
        case errorDecodeData(type: Codable.Type, error: Error)
        case errorEncodeData(type: Codable.Type, error: Error)
        
        var prefix: String { get { "[LocalDataManager]" } }
        
        var message: String {
            get {
                switch self {
                case.genericError(let str): str
                case .errorDecodeData(let type, let error):
                    "Error while decoding \(String(describing: type.self)).\n\(error.localizedDescription)"
                case .errorEncodeData(let type, let error):
                    "Error while encoding \(String(describing: type.self)).\n\(error.localizedDescription)"
                }
            }
        }
        
    }
    
}

// MARK: MOVIES
extension LocalDataManager {
    
    func saveMovies(_ movies: [Item]) -> UnWrappedResult<[Item]> {
        do {
            let encodedData = try JSONEncoder().encode(movies)
            userDefaults.setValue(encodedData, forKey: Key.movies.rawValue)
            return .success(movies)
        } catch {
            return .failure(LocalDataManagerError.errorEncodeData(type: [Item].self, error: error))
        }
    }
    
    func getSavedMovies() -> UnWrappedResult<[Item]> {
        guard let encodedData = userDefaults.data(forKey: Key.movies.rawValue) else { return .success([]) }
        do {
            let decodedData = try JSONDecoder().decode([Item].self, from: encodedData)
            return .success(decodedData)
        } catch {
            return .failure(LocalDataManagerError.errorDecodeData(type: [Item].self, error: error))
        }
    }
    
    func saveMovie(_ movie: Item) -> UnWrappedResult<Item> {
        let savedMoviesResult = getSavedMovies().result
        if let error = savedMoviesResult.error {
            return .failure(error)
        }
        if let data = savedMoviesResult.data {
            guard !data.contains(where: { $0.id == movie.id }) else {
                return .failure(LocalDataManagerError.genericError(str: "Movie already exist!"))
            }
            var newData = data
            newData.append(movie)
            let saveMoviesResult = saveMovies(newData).result
            if let error = saveMoviesResult.error {
                return .failure(error)
            }
            if let _ = saveMoviesResult.data {
                return .success(movie)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on saveMovie"))
    }
    
    func unSaveMovie(_ movie: Item) -> UnWrappedResult<Item> {
        let savedMoviesResult = getSavedMovies().result
        if let error = savedMoviesResult.error {
            return .failure(error)
        }
        if let data = savedMoviesResult.data {
            guard data.contains(where: {$0.id == movie.id }) else {
                return .failure(LocalDataManagerError.genericError(str: "Movie doesn't exists in library"))
            }
            var newData = data
            newData.removeAll(where: {$0.id == movie.id })
            let saveMoviesResult = saveMovies(newData).result
            if let error = saveMoviesResult.error {
                return .failure(error)
            }
            if let _ = saveMoviesResult.data {
                return .success(movie)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on unSaveMovie"))
    }
}

// MARK: TVSHOWS
extension LocalDataManager {
    
    func saveTvShows(_ tvShows: [Item]) -> UnWrappedResult<[Item]> {
        do {
            let encodedData = try JSONEncoder().encode(tvShows)
            userDefaults.setValue(encodedData, forKey: Key.tvShows.rawValue)
            return .success(tvShows)
        } catch {
            return .failure(LocalDataManagerError.errorEncodeData(type: [Item].self, error: error))
        }
    }
    
    func getSavedTvShows() -> UnWrappedResult<[Item]> {
        guard let encodedData = userDefaults.data(forKey: Key.tvShows.rawValue) else { return .success([]) }
        do {
            let decodedData = try JSONDecoder().decode([Item].self, from: encodedData)
            return .success(decodedData)
        } catch {
            return .failure(LocalDataManagerError.errorDecodeData(type: [Item].self, error: error))
        }
    }
    
    func saveTvShow(_ tvShow: Item) -> UnWrappedResult<Item> {
        let savedTvShowsResult = getSavedTvShows().result
        if let error = savedTvShowsResult.error {
            return .failure(error)
        }
        if let data = savedTvShowsResult.data {
            guard !data.contains(where: { $0.id == tvShow.id }) else {
                return .failure(LocalDataManagerError.genericError(str: "TV Show already exist!"))
            }
            var newData = data
            newData.append(tvShow)
            let saveTvShowsResult = saveTvShows(newData).result
            if let error = saveTvShowsResult.error {
                return .failure(error)
            }
            if let _ = saveTvShowsResult.data {
                return .success(tvShow)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on saveTvShow"))
    }
    
    func unSaveTvShow(_ tvShow: Item) -> UnWrappedResult<Item> {
        let savedTvShowsResult = getSavedTvShows().result
        if let error = savedTvShowsResult.error {
            return .failure(error)
        }
        if let data = savedTvShowsResult.data {
            guard data.contains(where: {$0.id == tvShow.id }) else {
                return .failure(LocalDataManagerError.genericError(str: "Tv Show doesn't exists in library"))
            }
            var newData = data
            newData.removeAll(where: {$0.id == tvShow.id })
            let saveTvShowsResult = saveTvShows(newData).result
            if let error = saveTvShowsResult.error {
                return .failure(error)
            }
            if let _ = saveTvShowsResult.data {
                return .success(tvShow)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on unSaveTvShow"))
    }
}

// MARK: ITEM DATA INFO
extension LocalDataManager {
    
    func saveItemsDataInfo(_ itemsDataInfo: [ItemDataInfo]) -> UnWrappedResult<[ItemDataInfo]> {
        do {
            let encodedData = try JSONEncoder().encode(itemsDataInfo)
            userDefaults.setValue(encodedData, forKey: Key.itemDataInfo.rawValue)
            return .success(itemsDataInfo)
        } catch {
            return .failure(LocalDataManagerError.errorEncodeData(type: [ItemDataInfo].self, error: error))
        }
    }
    
    func getItemsDataInfo() -> UnWrappedResult<[ItemDataInfo]> {
        guard let encodedData = userDefaults.data(forKey: Key.itemDataInfo.rawValue) else { return .success([]) }
        do {
            let decodedData = try JSONDecoder().decode([ItemDataInfo].self, from: encodedData)
            return .success(decodedData)
        } catch {
            return .failure(LocalDataManagerError.errorDecodeData(type: [ItemDataInfo].self, error: error))
        }
    }
    
    func getItemDataInfo(from id: Int, where type: ItemDataInfo.Tpe) -> UnWrappedResult<ItemDataInfo> {
        let itemsDataInfoResult = getItemsDataInfo().result
        if let error = itemsDataInfoResult.error {
            return .failure(error)
        }
        if let data = itemsDataInfoResult.data {
            let filteredItems = data.filter({ $0.type == type })
            let itemDataInfo = filteredItems.first(where: { $0.id == id }) ?? ItemDataInfo(id: id, type: type)
            return .success(itemDataInfo)
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on getItemDataInfo"))
    }
    
    func saveItemDataInfo(_ itemDataInfo: ItemDataInfo) -> UnWrappedResult<ItemDataInfo> {
        let deleteItemDataInfoResult = deleteItemDataInfo(itemDataInfo).result
        if let error = deleteItemDataInfoResult.error {
            return .failure(error)
        }
        if var data = deleteItemDataInfoResult.data {
            data.append(itemDataInfo)
            let saveItemsDataInfoResult = saveItemsDataInfo(data).result
            if let error = saveItemsDataInfoResult.error {
                return .failure(error)
            }
            if let data = saveItemsDataInfoResult.data {
                return .success(itemDataInfo)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on saveItemDataInfo"))
    }
    
    func deleteItemDataInfo(_ itemDataInfo: ItemDataInfo) -> UnWrappedResult<[ItemDataInfo]> {
        let itemsDataInfoResult = getItemsDataInfo().result
        if let error = itemsDataInfoResult.error {
            return .failure(error)
        }
        if var data = itemsDataInfoResult.data {
            data.removeAll(where: { $0.id == itemDataInfo.id && $0.type == itemDataInfo.type })
            let saveItemsDataInfoResult = saveItemsDataInfo(data).result
            if let error = saveItemsDataInfoResult.error {
                return .failure(error)
            }
            if let data = saveItemsDataInfoResult.data {
                return .success(data)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on deleteItemDataInfo"))
    }
}
