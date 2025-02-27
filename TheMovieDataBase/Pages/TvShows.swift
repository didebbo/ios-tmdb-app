//
//  TvShows.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 16/02/25.
//

import UIKit

class TvShows: BaseTableViewController {
    
    private var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in guard let self else { return }
                tableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        DataProvider.shared.getTvShows { [weak self] item in guard let self else { return }
            let itemResult = item.result
            if let error = itemResult.error {
                DispatchSerialQueue.main.async { [weak self] in guard let self else { return }
                    present(CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert), animated: true)
                }
            }
            if let data = itemResult.data {
                items = data
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Shows"
        tableView.register(ItemTableCell.self, forCellReuseIdentifier: String(describing: ItemTableCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleSettingsIcon()
        fetchData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ItemTableCell.self), for: indexPath) as? ItemTableCell
        let item = items[indexPath.row]
        cell?.configure(with: item)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = Detail(of: item)
        vc.title = "TV Show"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ItemTableCell.heightForRowAt
    }
}
