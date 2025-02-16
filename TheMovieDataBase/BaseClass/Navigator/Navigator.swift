//
//  Navigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import SnapKit

class Navigator: BaseNavigationController {
    
    var destinations: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        
        setViewControllers(destinations, animated: false)
    }
}
