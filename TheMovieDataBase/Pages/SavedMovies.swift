//
//  SavedMovies.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 19/02/25.
//

import UIKit

class SavedMovies: BaseTableViewController {
    
    private var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in guard let self else { return }
                tableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        let savedMoviesResult = DataProvider.shared.getSavedMovies().result
        if let error = savedMoviesResult.error {
            DispatchSerialQueue.main.async { [weak self] in guard let self else { return }
                let alert = CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert)
                present(alert, animated: true)
            }
        }
        if let data = savedMoviesResult.data {
            items = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        tableView.register(ItemTableCell.self, forCellReuseIdentifier: String(describing: ItemTableCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        vc.title = "Movie"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ItemTableCell.heightForRowAt
    }
}
