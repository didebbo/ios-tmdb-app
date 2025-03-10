//
//  Library.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import SnapKit

class Library: BaseViewController {
    
    private var destinations: [TopNavigationBar.Item.Destination]
    
    private lazy var topNavigationBar: TopNavigationBar = {
        let view = TopNavigationBar(destinations: destinations)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        
        view.register(LibraryCollectionCell.self, forCellWithReuseIdentifier: String(describing: LibraryCollectionCell.self))
        
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        
        view.addSubview(topNavigationBar)
        view.addSubview(collectionView)
        
        destinations.forEach { destination in
            addChild(destination.viewController)
            destination.viewController.didMove(toParent: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleSettingsIcon()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        topNavigationBar.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(TopNavigationBar.itemHeight)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let snapTo = (navigationController as? BottomNavigator)?.bottomNavigationBar.snp.top ?? view.snp.bottom
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(topNavigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(snapTo)
        }
    }
    
    init(destinations: [TopNavigationBar.Item.Destination]) {
        self.destinations = destinations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Library {
    
    class LibraryCollectionCell: UICollectionViewCell {
        
        func configure(with destination: TopNavigationBar.Item.Destination) {
            guard let view = destination.viewController.view else { return }
            contentView.addSubview(view)
            view.snp.remakeConstraints({ make in
                make.top.leading.bottom.trailing.equalToSuperview()
            })
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            contentView.subviews.forEach { view in
                view.removeFromSuperview()
            }
        }
    }
}

extension Library: TopNavigationBarDelegate {
    
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int) {
        guard currentIndex != destinationIndex else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in guard let self else { return }
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(row: destinationIndex, section: 0), at: .centeredHorizontally, animated: true)
        } completion: { [weak self] _ in guard let self else { return }
            collectionView.isPagingEnabled = true
        }
    }
}

extension Library: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LibraryCollectionCell.self), for: indexPath) as? LibraryCollectionCell
        let destination = destinations[indexPath.row]
        cell?.configure(with: destination)
        return cell!
    }
}

extension Library: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width
        
        let index = Int((scrollView.contentOffset.x + (0.5 * cellWidth)) / cellWidth)
        
        if index >= 0 && index < destinations.count {
            topNavigationBar.updateCurrentIndex(with: index)
        }
    }
}
