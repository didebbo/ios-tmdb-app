//
//  Saved.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import SnapKit

class Saved: BaseViewController {
    
    private lazy var topNavigationBar: TopNavigationBar = {
        let view = TopNavigationBar(destinations: [
            TopNavigationBar.Item.Destination(title: "Movies", dataSource: []),
            TopNavigationBar.Item.Destination(title: "Tv Shows", dataSource: [])
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
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
}
