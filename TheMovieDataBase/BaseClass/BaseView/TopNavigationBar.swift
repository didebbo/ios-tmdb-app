//
//  TopNavigationBar.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Stevia

class TopNavigationBar: UIView {
    
    static let itemHeight: CGFloat = 40
    
    struct Destination {
        let title: String
        let dataSource: [Item]
    }
    
    private var destinations: [Destination] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let count = destinations.count
        let width = UIApplication.shared.size.width
        let itemWidth = width / CGFloat(count)
        layout.itemSize = CGSize(width: width, height: TopNavigationBar.itemHeight)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
}
