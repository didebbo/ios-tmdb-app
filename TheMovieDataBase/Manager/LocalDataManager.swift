//
//  LocalDataManager.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 19/02/25.
//

import Foundation

struct LocalDataManager {
    
    enum Key: String {
        case movies = "savedMovies"
        case tvShows = "savedTvShows"
    }
    
    enum LocalDataManagerError: ApplicationError {
        case genericError(str: String)
        case errorJsonDecode(type: Codable.Type, error: Error)
        case errorJsonEncode(type: Codable.Type, error: Error)
        
        var prefix: String { get { "[LocalDataManager]" } }
        
        var message: String {
            get {
                switch self {
                case.genericError(let str): str
                case .errorJsonDecode(let type, let error):
                    "Error while decoding \(String(describing: type.self)).\n\(error.localizedDescription)"
                case .errorJsonEncode(let type, let error):
                    "Error while encoding \(String(describing: type.self)).\n\(error.localizedDescription)"
                }
            }
        }
        
    }
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    func getSavedMovies() -> UnWrappedResult<[Item]> {
        guard let encodedData = userDefaults.data(forKey: Key.movies.rawValue) else { return .success([]) }
        do {
            let decodedData = try JSONDecoder().decode([Item].self, from: encodedData)
            return .success(decodedData)
        } catch {
            return .failure(LocalDataManagerError.errorJsonDecode(type: [Item].self, error: error))
        }
    }
    
    func saveMovies(_ movies: [Item]) -> UnWrappedResult<[Item]> {
        do {
            let encodedData = try JSONEncoder().encode(movies)
            userDefaults.setValue(encodedData, forKey: Key.movies.rawValue)
            return .success(movies)
        } catch {
            return .failure(LocalDataManagerError.errorJsonEncode(type: [Item].self, error: error))
        }
    }
    
    func saveMovie(_ movie: Item) -> UnWrappedResult<Item> {
        let savedMoviesResult = getSavedMovies().result
        if let error = savedMoviesResult.error {
            return .failure(error)
        }
        if let data = savedMoviesResult.data {
            guard !data.contains(where: { $0.id == movie.id }) else {
                return .failure(LocalDataManagerError.genericError(str: "Movie Already Exist!"))
            }
            var newData = data
            newData.append(movie)
            let saveMoviesResult = saveMovies(newData).result
            if let error = saveMoviesResult.error {
                return .failure(error)
            }
            if let data = saveMoviesResult.data {
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
            if let data = saveMoviesResult.data {
                return .success(movie)
            }
        }
        return .failure(LocalDataManagerError.genericError(str: "Unhandled error on unSaveMovie"))
    }
}
