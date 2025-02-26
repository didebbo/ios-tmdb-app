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
    lazy var watchTime: Int = Range(0...1_000).randomElement() ?? 0
    lazy var like: Int = Range(0...watchTime).randomElement() ?? 0
    
    enum Tpe: Codable {
        case movie
        case tvShow
    }
}
