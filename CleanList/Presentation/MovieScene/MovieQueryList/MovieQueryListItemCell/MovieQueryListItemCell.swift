//
//  MovieQueryListItemCell.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

class MovieQueryListItemCell: UITableViewCell {

    var viewModel: MovieQueryListItemViewModelProtocol? {
        didSet {
            var config = defaultContentConfiguration()
            config.text = viewModel?.queryString
            contentConfiguration = config
        }
    }
}
