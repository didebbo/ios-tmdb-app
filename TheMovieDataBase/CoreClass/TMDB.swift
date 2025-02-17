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
    
    enum EndPoint {
        case discoverMovie
        
        func urlString(host: String) -> String {
            switch self {
            case .discoverMovie:
                "\(host)discover/movie"
            }
        }
    }
    
    enum TMDB_Error: Error {
        case nullData
        case genericError(String)
        
        var description: String {
            switch self {
            case .nullData:
                "Data is NULL"
            case .genericError(let str):
                "Generic Error: \(str)"
            }
        }
    }
    
    init(ACCESS_TOKEN: String) { self.ACCESS_TOKEN = ACCESS_TOKEN }
    
    func getUrl(from endpoint: EndPoint) -> URL? {
        URL(string: endpoint.urlString(host: host))
    }
    
    func getImageUrl(from path: String) -> URL? {
        URL(string: "\(imageHost)\(path)")
    }
    
    func getRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func getResponse(from request: URLRequest, completion: @escaping (_ response: Response) -> Void) {
        URLSession.shared.dataTask(with: request) { d, r, e in
            var response = Response()
            
            response.statusCode = (r as? HTTPURLResponse)?.statusCode
            response.error = e
            do {
                guard let d else { throw TMDB_Error.nullData }
                let jsonObject = try JSONSerialization.jsonObject(with: d, options: [])
                response.jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                response.error = error
            }
            
            if response.statusCode != 200 {
                response.error = response.error ?? TMDB_Error.genericError(String(describing: response.statusCode))
            }
            
            completion(response)
        }.resume()
    }
}
