//
//  Navigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class Navigator: BaseNavigationController {
    
    lazy var bottomNavigationBar: BottomNavigationBar = {
        let view = BottomNavigationBar(detstinations: [Main(),UIViewController()])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        handleBottomNavigationBar()
        setViewControllers([Main()], animated: true)
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

