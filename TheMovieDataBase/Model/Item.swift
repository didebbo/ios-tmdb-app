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
    var watchTime: Int
    var like: Int
    
    enum Tpe: Codable {
        case movie
        case tvShow
    }
    
    init(id: Int, type: Tpe, saved: Bool, watchTime: Int? = nil, like: Int? = nil) {
        self.id = id
        self.type = type
        self.saved = saved
        self.watchTime = watchTime ?? Range(0...1_000).randomElement() ?? 0
        self.like = like ?? Range(0...self.watchTime).randomElement() ?? 0
    }
}
