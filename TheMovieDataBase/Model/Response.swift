//
//  Response.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Foundation

struct Response {
    var statusCode: Int?
    var error: Error?
    var jsonData: Any?
}
