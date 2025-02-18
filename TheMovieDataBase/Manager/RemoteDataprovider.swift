//
//  RemoteDataprovider.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 18/02/25.
//

import Foundation

struct RemoteDataProvider {
    
    private enum RemoteDataProviderError: ApplicationError {
        case invalidUrl(url: String)
        case responseError(url: String, error: Error, data: String)
        case invalidStatusCode(url: String, code: Int, data: String)
        case invalidJsonType(type: Codable.Type)
        case dataIsNull
        
        var prefix: String { "[RemoteDataProvider]\n" }
        
        func description() -> String {
            var str: String {
                switch self {
                case .invalidUrl(let url):
                    "Invalid URL: \(url)"
                case .responseError(let url, let error, let data):
                    "From URL: \(url)\nResponse Error: \(error.localizedDescription)\nData: \(data)"
                case .invalidStatusCode(let url, let code, let data):
                    "From URL: \(url)\nInvalid Status Code: \(code)\nData: \(data)"
                case .invalidJsonType(let type):
                    "Invalid Json \(String(describing: type.self))"
                case .dataIsNull:
                    "Data is null"
                }
            }
            return "\(prefix)\(str)"
        }
    }
    
    static func getUrl(from urlString: String) -> UnWrappedResult<URL> {
        guard let url = URL(string: urlString) else {
            return .failure(RemoteDataProviderError.invalidUrl(url: urlString))
        }
        return .success(url)
    }
    
    static func getRequest(from url: URL, header: [String: String]) -> URLRequest {
        var request = URLRequest(url: url)
        header.forEach { (key: String, value: String) in
            request.setValue(key, forHTTPHeaderField: value)
        }
        return request
    }
    
    static func fetchData(from request: URLRequest, completion: @escaping (_ response: UnWrappedResult<Data>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            let urlString = response?.url?.absoluteString ?? "Undefined"
            var dataString = "Undefined"
            if let data, let safeDataString = String(data: data, encoding: .utf8) { dataString = safeDataString }
            
            if let error {
                completion(.failure(RemoteDataProviderError.responseError(url: urlString, error: error, data: dataString)))
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode != 200 {
                completion(.failure(RemoteDataProviderError.invalidStatusCode(url: urlString, code: statusCode, data: dataString)))
                return
            }
            guard let data else {
                completion(.failure(RemoteDataProviderError.dataIsNull))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    static func getDecodedJson<M: Codable>(from data: Data, to model: M.Type) -> UnWrappedResult<M> {
        do {
            let decodedJson = try JSONDecoder().decode(model, from: data)
            return .success(decodedJson)
        } catch {
            return .failure(RemoteDataProviderError.invalidJsonType(type: model))
        }
    }
}
