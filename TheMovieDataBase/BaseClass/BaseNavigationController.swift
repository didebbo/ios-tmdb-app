//
//  BaseNavigationController.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import UIKit

class BaseNavigationController: CoreNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(resource: .primary)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        view.backgroundColor = UIColor.white
    }
}
