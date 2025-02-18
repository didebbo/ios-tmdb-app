//
//  Movies.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import UIKit

class Movies: BaseTableViewController {
    
    private var movies: [Item] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in guard let self else { return }
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        tableView.register(ItemTableCell.self, forCellReuseIdentifier: String(describing: ItemTableCell.self))
        
        DataProvider.shared.getMovies { item in
            item.hasData { [weak self] data in guard let self else { return }
                movies = data
            }
            item.hasError { [weak self] error in guard let self else { return }
                DispatchSerialQueue.main.async {
                    let alert = UIAlertController(title: "Attenzione", message: error.description(), preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ItemTableCell.self), for: indexPath) as? ItemTableCell
        let item = movies[indexPath.row]
        cell?.configure(with: item)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = movies[indexPath.row]
        let vc = Detail(of: item)
        vc.title = "Movie"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
