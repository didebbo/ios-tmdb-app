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
        
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        
        appearance.backButtonAppearance = backButtonAppearance
        
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor.white
    }
}
