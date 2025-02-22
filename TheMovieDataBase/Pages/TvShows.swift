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
    
    private func fethData() {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fethData()
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
        cell?.delegate = self
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = Detail(of: item)
        vc.delegate = self
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
                fethData()
            }
        }
    }
}

extension TvShows: ItemTableCellDelegate {
    func didTapSave(item: Item) {
       saveTvShow(item: item)
    }
}

extension TvShows: DetailDelegate {
    func didTapSave(itemDetail: Item) {
        saveTvShow(item: itemDetail)
    }
}
