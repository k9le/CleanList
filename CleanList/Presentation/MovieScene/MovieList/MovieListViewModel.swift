//
//  MovieListViewModel.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//

import Foundation

protocol MovieListViewModelInput: class {
    func initialize(with data: [MovieListItem])
}

protocol MovieListViewModelOutput: class {
    var listUpdate: Observable<[MovieListItemViewModelProtocol]> { get }
}

protocol MovieListViewModelProtocol: MovieListViewModelInput, MovieListViewModelOutput {}

class MovieListViewModel: MovieListViewModelProtocol {
    
    private var imageDataProvider: MovieImageDataProviderProtocol
    
    private var listUpdateObservable: Observable<[MovieListItemViewModelProtocol]> = .init([])
    
    init(imageDataProvider: MovieImageDataProviderProtocol) {
        self.imageDataProvider = imageDataProvider
    }
    
    // MARK: - MovieListViewModelInput
    func initialize(with data: [MovieListItem]) {
        listUpdate.value = data.map {
            MovieListItemViewModel(with: $0, imageDataProvider: imageDataProvider)
        }
    }
    
    // MARK: - MovieListViewModelOutput
    var listUpdate: Observable<[MovieListItemViewModelProtocol]> { listUpdateObservable }
    
}
