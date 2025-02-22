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
    var dataInfo: DataInfo
    
    struct DataInfo: Codable {
        var saved: Bool?
        var watchTime: Int = 0
        var like: Int = 0
    }
}
