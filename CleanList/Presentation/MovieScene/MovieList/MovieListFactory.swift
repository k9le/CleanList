//
//  MovieListFactory.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//

import UIKit

protocol MovieListDataSetterProtocol {
    func setData(_ data: [MovieListItem])
}

protocol MovieListFactoryProtocol: ControllerFactory, MovieListDataSetterProtocol {}

class MovieListFactory: MovieListFactoryProtocol {
    private var data: [MovieListItem] = []
    
    func setData(_ data: [MovieListItem]) {
        self.data = data
    }
    
    func create() -> UIViewController {
        
        let networkService = NetworkService(
            session: URLSession.shared,
            decoder: JSONDecoder()
        )
        
        let imageDataProvider = MovieImageDataProvider(networkService: networkService)
        
        let viewModel = MovieListViewModel(imageDataProvider: imageDataProvider)
        viewModel.initialize(with: data)
        
        let vc = MovieListViewController()
        vc.viewModel = viewModel
        return vc
    }
}
