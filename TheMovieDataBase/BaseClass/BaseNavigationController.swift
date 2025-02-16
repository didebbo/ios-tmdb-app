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
            .foregroundColor: UIColor(resource: .tertiary)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(resource: .secondary)
        ]
        
        
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        view.backgroundColor = UIColor(resource: .primary)
    }
}
