//
//  Item.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Foundation

struct Item: Codable {
    let id: Int?
    let title: String?
    let description: String?
    var posterPath: String?
    var coverPath: String?
}
