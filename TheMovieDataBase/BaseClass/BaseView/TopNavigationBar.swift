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
    
    private var destinations: [Destination]
    
    private lazy var itemSize: CGSize = {
        let count = destinations.count
        let width = UIApplication.shared.screenSize.width
        let itemWidth = width / CGFloat(count)
        return CGSize(width: itemWidth, height: TopNavigationBar.itemHeight)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = itemSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = .zero
        collection.backgroundColor = UIColor(resource: .primary)
        
        // collection.dataSource = self
        // collection.delegate = self
        
        return collection
    }()
    
    init(destinations: [Destination]) {
        self.destinations = destinations
        super.init(frame: .zero)
        backgroundColor = UIColor(resource: .primary)
        
        subviews(collectionView)
        layout {
            0
            |-0--collectionView--0-|
            0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
