//
//  BottomNavigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class BottomNavigator: BaseNavigationController {
    
    var destinations: [BottomNavigationBar.Destination] = []
    
    lazy var bottomNavigationBar: BottomNavigationBar = {
        let view = BottomNavigationBar(detstinations: destinations)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        setViewControllers(destinations.compactMap({ $0.viewController }), animated: false)
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

