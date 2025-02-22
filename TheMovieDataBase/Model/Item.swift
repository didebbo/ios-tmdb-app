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
    let posterImageData: Data?
    let coverImageData: Data?
    let type: ItemDataInfo.Tpe
}

struct ItemDataInfo: Codable {
    let id: Int
    let type: Tpe
    var saved: Bool
    var watchTime: Int = 0
    var like: Int = 0
    
    enum Tpe: Codable {
        case movie
        case tvShow
    }
}
