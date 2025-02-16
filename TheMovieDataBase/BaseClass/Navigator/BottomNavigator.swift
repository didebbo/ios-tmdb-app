//
//  BottomNavigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class BottomNavigator: BaseNavigationController {
    
    var destinations: [BottomNavigationBar.Item.Destination] = []
    
    lazy var bottomNavigationBar: BottomNavigationBar = {
        let view = BottomNavigationBar(detstinations: destinations)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        if let firstDestination = destinations.first {
            setViewControllers([firstDestination.viewController], animated: false)
        }
        handleBottomNavigationBar()
    }
    
    private func handleBottomNavigationBar() {
        view.addSubview(bottomNavigationBar)
        bottomNavigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(BottomNavigationBar.itemHeight)
            make.bottom.equalToSuperview()
        }
    }
}

