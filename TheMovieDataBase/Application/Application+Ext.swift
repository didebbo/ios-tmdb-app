//
//  Application+Ext.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import UIKit

extension UIApplication {
    var screenSize: CGSize { (connectedScenes.first as? UIWindowScene)?.screen.bounds.size ?? .zero }
}
