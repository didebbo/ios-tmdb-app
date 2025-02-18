//
//  CoreTableViewController.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import UIKit

class CoreTableViewController: UITableViewController {
    
    private lazy var animationLayer: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: UIApplication.shared.screenSize))
        view.backgroundColor = .white
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(animationLayer)
        animationLayer.alpha = 1
        animationLayer.layer.zPosition = 999
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in guard let self else { return }
            animationLayer.alpha = 0
        } completion: { [weak self] _ in guard let self else { return }
            animationLayer.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in guard let self else { return }
            view.alpha = 0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.alpha = 1
    }
}
