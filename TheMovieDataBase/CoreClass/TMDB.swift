//
//  TMDB.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct TMDB {
    
    private let ACCESS_TOKEN: String
    private let host: String = "https://api.themoviedb.org/3/"
    private let imageHost: String = "https://image.tmdb.org/t/p/w500"
    
    enum EndPoint: String {
        case discoverMovie = "discover/movie"
        
        func urlString(host: String) -> String {
            switch self {
            case .discoverMovie:
                "\(host)\(self.rawValue)"
            }
        }
    }
    
    enum TMDB_Error: Error {
        case invalidUrl(urlString: String)
        case invalidStatusCode(code: Int)
        case nullData
        case genericError(String)
        
        var description: String {
            switch self {
            case .invalidUrl(let urlString):
                "Invalid URL: \(urlString)"
            case .invalidStatusCode(let code):
                "Invalid statusCode: \(code)"
            case .nullData:
                "Data is NULL"
            case .genericError(let str):
                "Generic Error: \(str)"
            }
        }
    }
    
    init(ACCESS_TOKEN: String) { self.ACCESS_TOKEN = ACCESS_TOKEN }
    
    func getUrl(from endpoint: EndPoint) -> SafeResult<URL> {
        let url = URL(string: endpoint.urlString(host: host))
        if let url { return .success(url) }
        return .failure(.invalidUrl(urlString: endpoint.urlString(host: host)))
    }
    
    func getImageUrl(from path: String) -> SafeResult<URL> {
        let url = URL(string: "\(imageHost)\(path)")
        if let url { return .success(url) }
        return .failure(.invalidUrl(urlString: "\(host)\(path)"))
    }
    
    func getRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func getImageData(from url: URL, completion: @escaping (_ response: SafeResult<Data>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.genericError(error.localizedDescription)))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                completion(.failure(.invalidStatusCode(code: statusCode)))
                return
            }
            
            if let data {
                completion(.success(data))
                return
            }
            
            completion(.failure(.nullData))
        }.resume()
    }
    
    func getResponse(from request: URLRequest, completion: @escaping (_ response: SafeResult<Data>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                completion(.failure(.genericError(error.localizedDescription)))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                completion(.failure(.invalidStatusCode(code: statusCode)))
                return
            }
            
            if let data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
                    completion(.success(jsonData))
                    return
                } catch {
                    completion(.failure(.genericError(error.localizedDescription)))
                    return
                }
            }
            
            completion(.failure(.nullData))
        }.resume()
    }
}
