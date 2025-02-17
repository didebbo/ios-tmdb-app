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
        handleBottomNavigator()
    }
    
    private func handleBottomNavigator() {
        guard let nc: BottomNavigator = navigationController as? BottomNavigator else { return }
        
        let vs = nc.view.bounds.size
        let bbs = nc.bottomNavigationBar.bounds.size
        let safeHeight = vs.height - bbs.height
        
        view.snp.makeConstraints { make in
            make.height.equalTo(safeHeight)
            make.width.equalTo(vs.width)
        }
    }
}
