//
//  TopNavigationBar.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Stevia

protocol TopNavigationBarDelegate: AnyObject {
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int)
}

class TopNavigationBar: UIView {
    
    static let itemHeight: CGFloat = 40
    
    weak var delegate: TopNavigationBarDelegate?
    
    private var destinations: [Item.Destination]
    private var currentIndex: Int = 0
    
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
        
        collection.register(Item.self, forCellWithReuseIdentifier: String(describing: Item.self))
        
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    
    init(destinations: [Item.Destination]) {
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
    
    func updateCurrentIndex(with index: Int) {
        currentIndex = index
        collectionView.reloadData()
    }
}

extension TopNavigationBar {
    
    class Item: UICollectionViewCell {
        
        struct Destination {
            let title: String
            let viewController: UIViewController
        }
        
        private lazy var labelText: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(resource: .tertiary)
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            label.textAlignment = .center
            return label
        }()
        
        func configure(destination: Destination, isSelected: Bool) {
            labelText.text = destination.title
            
            if isSelected {
                labelText.textColor = UIColor.white
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            labelText.textColor = UIColor(resource: .tertiary)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.subviews(labelText)
            contentView.layout {
                (>=0)
                |-(>=0)--labelText--(>=0)-|
                (>=0)
            }
            labelText.centerInContainer()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension TopNavigationBar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Item.self), for: indexPath) as? Item
        item?.configure(destination: destinations[indexPath.row], isSelected: currentIndex == indexPath.row)
        return item!
    }
}

extension TopNavigationBar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationIndex = indexPath.row
        delegate?.didSelectItemAt(currentIndex: currentIndex, destinationIndex: destinationIndex)
        currentIndex = destinationIndex
        collectionView.reloadData()
    }
}
