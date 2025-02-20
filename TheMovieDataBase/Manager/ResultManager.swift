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
    
    var result: (data: Data?, error: ApplicationError?) {
        switch self {
        case .success(let data):
            (data,nil)
        case .failure(let error):
            (nil,error)
        }
    }
}
