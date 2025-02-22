//
//  SavedTvShows.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 19/02/25.
//

import UIKit

class SavedTvShows: BaseTableViewController {
    
    private var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in guard let self else { return }
                tableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        let savedTvShowsResult = DataProvider.shared.getSavedTvShows().result
        if let error = savedTvShowsResult.error {
            present(CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert), animated: true)
        }
        if let data = savedTvShowsResult.data {
            items = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Shows"
        tableView.register(ItemTableCell.self, forCellReuseIdentifier: String(describing: ItemTableCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    private func saveTvShow(item: Item) {
        let hasSavedTvShowResult = DataProvider.shared.hasSavedTvShow(item.id).result
        if let error = hasSavedTvShowResult.error {
            present(CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert), animated: true)
        }
        if let hasSavedTvShow = hasSavedTvShowResult.data {
            let operationResult = hasSavedTvShow ? DataProvider.shared.unSaveTvShow(item).result : DataProvider.shared.saveTvShow(item).result
            if let error = operationResult.error {
                present(CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert), animated: true)
            }
            if let _ = operationResult.data {
                fetchData()
            }
        }
    }
}
