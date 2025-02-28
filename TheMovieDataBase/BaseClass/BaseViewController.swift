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
        
        view.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(safeHeight)
            make.width.equalTo(vs.width)
        }
    }
    
    func handleSettingsIcon() {
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(presentSettings))
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    func handleCloseIcon() {
        let closeBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(dismissCloseButton))
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    @objc private func presentSettings() {
        let vc = Settings()
        let nc = BaseNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
    
    @objc private func dismissCloseButton() {
        dismiss(animated: true)
    }
}
