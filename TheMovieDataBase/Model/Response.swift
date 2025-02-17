//
//  Response.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

enum SafeResult<R> {
    case success(R)
    case failure(Error)
    
    func hasError(completion: @escaping (_ error: Error) -> Void) {
        switch self {
        case .failure(let error): completion(error)
        default: break
        }
    }
    
    func hasData(completion: @escaping (_ data: R) -> Void) {
        switch self {
        case .success(let r): completion(r)
        default: break
        }
    }
}

struct Response {
    var statusCode: Int?
    var error: Error?
    var jsonData: Data?
}

struct MovieResponse: Codable {
    let results: [Movie]
    
    struct Movie: Codable {
        let id: Int
        let title: String
        let overview: String
        let backdrop_path: String
        let poster_path: String
    }
}
