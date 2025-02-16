//
//  Saved.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import SnapKit

class Saved: BaseViewController {
    
    private var destinations: [TopNavigationBar.Item.Destination]
    
    private lazy var topNavigationBar: TopNavigationBar = {
        let view = TopNavigationBar(destinations: destinations)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        
        view.addSubview(topNavigationBar)
        topNavigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(TopNavigationBar.itemHeight)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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

extension Saved: TopNavigationBarDelegate {
    
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int) {
        guard currentIndex != destinationIndex else { return }
    }
}
