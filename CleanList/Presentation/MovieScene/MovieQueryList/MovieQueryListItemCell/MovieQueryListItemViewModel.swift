//
//  MovieQueryListItemViewModel.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import Foundation

protocol MovieQueryListItemViewModelProtocol {
    var queryString: String { get }
}

struct MovieQueryListItemViewModel: MovieQueryListItemViewModelProtocol {
    let queryString: String
}
