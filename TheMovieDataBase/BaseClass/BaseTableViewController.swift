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
        handleBottomNavigator()
    }
    
    private func handleBottomNavigator() {
        guard let nc: BottomNavigator = navigationController as? BottomNavigator else { return }
        let vs = nc.view.bounds.size
        let bbs = nc.bottomNavigationBar.bounds.size
        
        view.snp.makeConstraints { make in
            make.height.equalTo(vs.height - bbs.height)
            make.width.equalTo(vs.width)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
