//
//  Saved.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import UIKit

class Saved: BaseViewController {
    
    private lazy var topNavigationBar: TopNavigationBar = {
        let view = TopNavigationBar()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved"
    }
}
