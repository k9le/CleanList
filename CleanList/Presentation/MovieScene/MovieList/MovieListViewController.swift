//
//  MovieListViewController.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//

import UIKit

class MovieListViewController: UITableViewController {

    private struct Constants {
        static let cellIdentifier: String = "basicMovieCell"
    }

    var viewModel: MovieListViewModelProtocol! {
        didSet {
            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

private extension MovieListViewController {
    
    func setupTableView() {
        tableView.register(MovieListItemCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    func bindViewModel() {
        viewModel.listUpdate.observe(on: self) { [weak self] list in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Table view data source
extension MovieListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listUpdate.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MovieListItemCell else { return UITableViewCell() }
        
        cell.viewModel = viewModel.listUpdate.value[indexPath.row]
        cell.updateBlock = { [weak self] in
            self?.tableView.performBatchUpdates({}, completion: nil)
        }
        
        return cell
    }
}
