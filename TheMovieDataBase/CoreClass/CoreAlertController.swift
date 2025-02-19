//
//  CoreAlertController.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 19/02/25.
//

import UIKit

class CoreAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapView = UIView(frame: view.frame)
        tapView.backgroundColor = UIColor.clear
        tapView.isUserInteractionEnabled = true
        view.addSubview(tapView)
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        tapView.addGestureRecognizer(dismissGesture)
        tapView.isUserInteractionEnabled = true
    }
    
    @objc private func dismissAlert() {
        dismiss(animated: true)
    }

}
