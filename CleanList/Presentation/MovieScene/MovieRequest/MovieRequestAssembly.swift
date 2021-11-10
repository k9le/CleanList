//
//  MovieRequestAssembly.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

class MovieRequestAssembly {
    
    private static var movieListFactory = MovieListFactory()
    
    private static func createMovieRequestViewModel() -> MovieRequestViewModel {
        
        let networkService = NetworkService(
            session: URLSession.shared,
            decoder: JSONDecoder())
        
        let moviesPersistentStorage = MoviesPersistentStorage(persistentContainer: PersistentContainer.shared)
        let moviesDataProvider = MoviesDataProvider(networkService: networkService)
        let queryPersistentStorage = QueryPersistentStorage(persistentContainer: PersistentContainer.shared)
        
        let movieRepository = MoviesRepository(
            persistentStorage: moviesPersistentStorage,
            dataProvider: moviesDataProvider,
            queryCache: queryPersistentStorage
        )
        
        let useCase = RequestMovieListUseCase(
            querySaver: queryPersistentStorage,
            moviesRepository: movieRepository
        )
        
        return MovieRequestViewModel(
            movieListRequestUseCase: useCase,
            resultsSetter: Self.movieListFactory
        )
    }
    
    static func create() -> UIViewController {
        let vc = MovieRequestViewController()
        let viewModel = createMovieRequestViewModel()
        
        vc.queryListFactory = MovieQueryListFactory(with: viewModel.requested(_:))
        vc.resultsListFactory = Self.movieListFactory
        vc.viewModel = viewModel
        
        return vc
    }
}
