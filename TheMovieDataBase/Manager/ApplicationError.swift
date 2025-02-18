//
//  ApplicationError.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 18/02/25.
//

import Foundation

protocol ApplicationError: Error {
    func description() -> String
}
