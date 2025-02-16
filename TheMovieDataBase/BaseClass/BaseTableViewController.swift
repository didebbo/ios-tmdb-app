//
//  BaseTableViewController.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import UIKit

class BaseTableViewController: CoreTableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let navigator: Navigator = navigationController as? Navigator else { return }
        let viewSize = navigator.view.bounds.size
        let bottomNavigationBarSize = navigator.bottomNavigationBar.bounds.size
        
        view.snp.makeConstraints { make in
            make.height.equalTo(viewSize.height - bottomNavigationBarSize.height)
            make.width.equalTo(viewSize.width)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
