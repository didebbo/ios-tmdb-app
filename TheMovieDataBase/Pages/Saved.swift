//
//  Saved.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import Stevia

class Saved: BaseViewController {
    
    private lazy var topNavigationBar: TopNavigationBar = {
        let view = TopNavigationBar()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved"
        
        view.subviews(topNavigationBar)
        view.layout {
            0
            |-0--topNavigationBar--0-|
        }
        topNavigationBar.Height == TopNavigationBar.itemHeight
    }
}
