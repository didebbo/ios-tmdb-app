//
//  Movies.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import UIKit

class Movies: BaseTableViewController {
    
    private var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in guard let self else { return }
                tableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        DataProvider.shared.getMovies { item in
            item.hasData { [weak self] data in guard let self else { return }
                items = data
            }
            item.hasError { [weak self] error in guard let self else { return }
                DispatchSerialQueue.main.async {
                    let alert = CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
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
        cell?.delegate = self
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

extension Movies: ItemTableCellDelegate {
    
    func didTapSaveIcon(item: Item) {
        let result = DataProvider.shared.saveMovie(item)
        result.hasError { [weak self] error in guard let self else { return }
            let vc = CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert)
            present(vc, animated: true)
        }
        result .hasData { [weak self] _ in guard let self else { return }
            fetchData()
        }
    }
}
