//
//  UIViewController+Ext.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 27/02/25.
//

import UIKit

extension UIViewController {
    var isRootViewController: Bool {
        return self.navigationController?.viewControllers.first === self
    }
}
