//
//  MovieListViewModel.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//

import Foundation

protocol MovieListViewModelInput: AnyObject {
    func initialize(with data: [MovieListItem])
    func deinitialize()
}

protocol MovieListViewModelOutput: AnyObject {
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
    
    func deinitialize() {
        listUpdate.value.forEach {
            $0.cancelLoadingImage()
        }
    }

    
    // MARK: - MovieListViewModelOutput
    var listUpdate: Observable<[MovieListItemViewModelProtocol]> { listUpdateObservable }
    
}
