//
//  BaseViewController.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class BaseViewController: CoreViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let navigator: BottomNavigator = navigationController as? BottomNavigator else { return }
        let viewSize = navigator.view.bounds.size
        let bottomNavigationBarSize = navigator.bottomNavigationBar.bounds.size
        
        view.snp.makeConstraints { make in
            make.height.equalTo(viewSize.height - bottomNavigationBarSize.height)
            make.width.equalTo(viewSize.width)
        }
    }
}
