//
//  Item.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Foundation

struct Item: Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: URL
    let detailImage: URL
}
