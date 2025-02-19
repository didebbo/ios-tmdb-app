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
    
    func saveMovie(_ movie: Item) -> UnWrappedResult<[Item]> {
        let savedMoviesResult = getSavedMovies()
        var unWrappedResult: UnWrappedResult<[Item]> = .failure(LocalDataManagerError.genericError(str: "Unhandled error on saveMovie"))
        
        savedMoviesResult.hasError { error in
            unWrappedResult = .failure(error)
        }
        savedMoviesResult.hasData { data in
            guard !data.contains(where: { $0.id == movie.id }) else {
                unWrappedResult = .success(data)
                return
            }
            var newData = data
            newData.append(movie)
            
            do {
                let encodedData = try JSONEncoder().encode(newData)
                userDefaults.setValue(encodedData, forKey: Key.movies.rawValue)
                unWrappedResult = .success(newData)
            } catch {
                unWrappedResult = .failure(LocalDataManagerError.errorJsonEncode(type: [Item].self, error: error))
            }
        }
        return unWrappedResult
    }
}
