//
//  ApplicationError.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 18/02/25.
//

import Foundation

protocol ApplicationError: Error {
    var prefix: String { get }
    var message: String { get }
    var description: String { get }
}

extension ApplicationError {
    var description: String { "\(prefix)\n\(message)" }
}
