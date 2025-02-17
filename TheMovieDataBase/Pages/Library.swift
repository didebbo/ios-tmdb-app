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
        layout.itemSize = view.bounds.size
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.green
        
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        
        view.addSubview(topNavigationBar)
        view.addSubview(collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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

extension Library: TopNavigationBarDelegate {
    
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int) {
        guard currentIndex != destinationIndex else { return }
        
        
    }
}
