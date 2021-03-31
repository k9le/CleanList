//
//  MovieQueryListViewController.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

class MovieQueryListViewController: UITableViewController {
    
    private struct Constants {
        static let cellIdentifier: String = "basicCell"
    }

    var viewModel: MovieQueryListViewModelProtocol! {
        didSet {
            bindViewModel()
        }
    }
    private var cellModelsList: [MovieQueryListItemViewModelProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        viewModel.initialize()
    }
}

private extension MovieQueryListViewController {
    
    func setupTableView() {
        tableView.register(MovieQueryListItemCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    func bindViewModel() {
        viewModel.listUpdate.observe(on: self) { [weak self] list in
            self?.cellModelsList = list
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Table view data source
extension MovieQueryListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModelsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MovieQueryListItemCell else { return UITableViewCell() }
        
        cell.viewModel = cellModelsList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didChoose(indexPath.row)
    }

}
