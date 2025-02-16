//
//  BottomNavigationBar.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Stevia

class BottomNavigationBar: UIView {
    
    private let detstinations: [UIViewController]
    
    static let itemHeight: CGFloat = 80
    
    private lazy var itemSize: CGSize = {
        let count = self.detstinations.count
        let width = UIScreen.main.bounds.width
        let itemWidth = width / CGFloat(count)
        return CGSize(width: itemWidth, height: BottomNavigationBar.itemHeight)
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = itemSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collection
    }()
    
    init(detstinations: [UIViewController]) {
        self.detstinations = detstinations
        super.init(frame: .zero)
        backgroundColor = UIColor(resource: .primary)
        let _ = itemSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
