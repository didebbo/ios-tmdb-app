//
//  Navigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import UIKit

class Navigator: BaseNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        
        setViewControllers([Main()], animated: true)
    }
}

