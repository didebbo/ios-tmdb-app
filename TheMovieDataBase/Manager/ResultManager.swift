//
//  ResultManager.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 18/02/25.
//

import Foundation

enum UnWrappedResult<Data> {
    case success(Data)
    case failure(ApplicationError)
    
    func hasError(completion: @escaping (_ error: ApplicationError) -> Void) {
        switch self {
        case .failure(let error): completion(error)
        default: break
        }
    }
    
    func hasData(completion: @escaping (_ data: Data) -> Void) {
        switch self {
        case .success(let data): completion(data)
        default: break
        }
    }
    
    var result: (data: Data?, error: ApplicationError?) {
        switch self {
        case .success(let data):
            (data,nil)
        case .failure(let error):
            (nil,error)
        }
    }
}
