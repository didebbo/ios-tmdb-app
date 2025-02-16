//
//  BottomNavigationBar.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Stevia

protocol BottomNavigationBarDelegate: AnyObject {
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int)
}

class BottomNavigationBar: UIView {
    
    static let itemHeight: CGFloat = 80
    
    weak var delegate: BottomNavigationBarDelegate?
    
    private let destinations: [Item.Destination]
    private var currentIndex: Int = 0
    
    private lazy var itemSize: CGSize = {
        let count = destinations.count
        let width = UIApplication.shared.screenSize.width
        let itemWidth = width / CGFloat(count)
        return CGSize(width: itemWidth, height: BottomNavigationBar.itemHeight)
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = itemSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = .zero
        collection.backgroundColor = UIColor(resource: .primary)
        
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(Item.self, forCellWithReuseIdentifier: String(describing: Item.self))
        
        return collection
    }()
    
    init(detstinations: [BottomNavigationBar.Item.Destination]) {
        self.destinations = detstinations
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


extension BottomNavigationBar: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Item.self), for: indexPath) as? Item
        item?.configure(destination: destinations[indexPath.row], isSelected: currentIndex == indexPath.row)
        return item!
    }
}

extension BottomNavigationBar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationIndex = indexPath.row
        delegate?.didSelectItemAt(currentIndex: currentIndex, destinationIndex: destinationIndex)
        currentIndex = destinationIndex
        collectionView.reloadData()
    }
    
}

extension BottomNavigationBar {
    
    class Item: UICollectionViewCell {
        
        struct Destination {
            let text: String
            let icon: UIImage?
            let viewController: UIViewController
        }
        
        private lazy var labelText: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(resource: .secondary)
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textAlignment = .center
            return label
        }()
        
        private lazy var iconView: UIImageView = {
            let imageView = UIImageView()
            imageView.tintColor = UIColor(resource: .secondary)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        func configure(destination: Destination, isSelected: Bool) {
            labelText.text = destination.text
            iconView.image = destination.icon
            
            if isSelected {
                labelText.textColor = UIColor.white
                iconView.tintColor = UIColor.white
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            labelText.textColor = UIColor(resource: .secondary)
            iconView.tintColor = UIColor(resource: .secondary)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.subviews(iconView, labelText)
            contentView.layout {
                10
                |-(>=0)--iconView--(>=0)-|
                |-(>=0)--labelText--(>=0)-|
                (>=0)
            }
            
            iconView.Width == BottomNavigationBar.itemHeight / 2.5
            iconView.heightEqualsWidth()
            iconView.centerHorizontally()
            
            labelText.centerHorizontally()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

