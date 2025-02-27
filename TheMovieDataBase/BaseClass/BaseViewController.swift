//
//  BaseViewController.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class BaseViewController: CoreViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleSettingsIcon()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleBottomNavigator()
    }
    
    private func handleBottomNavigator() {
        guard let nc: BottomNavigator = navigationController as? BottomNavigator else { return }
        
        let vs = nc.view.bounds.size
        let bbs = nc.bottomNavigationBar.bounds.size
        let safeHeight = vs.height - bbs.height
        
        view.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(safeHeight)
            make.width.equalTo(vs.width)
        }
    }
    
    private func handleSettingsIcon() {
        guard isRootViewController else { return }
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(presentSettings))
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    @objc private func presentSettings() {
        let vc = Settings()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
