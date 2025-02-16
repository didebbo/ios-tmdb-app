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
            .foregroundColor: UIColor(resource: .tertiary),
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(resource: .secondary),
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        view.backgroundColor = UIColor(resource: .primary)
    }
}
