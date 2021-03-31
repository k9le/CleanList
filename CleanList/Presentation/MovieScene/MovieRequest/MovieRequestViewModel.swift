//
//  MovieRequestViewModel.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 13.03.2021.
//

import Foundation

enum MovieRequestStatus {
    case initial
    case loading
    case emptyResults
    case results
}

protocol MovieRequestViewModelInput: class {
    func initialize()
    func requested(_ request: String)
}

protocol MovieRequestViewModelOutput: class {
    var statusUpdate: Observable<MovieRequestStatus> { get }
    var queryText: Observable<String> { get }
}

protocol MovieRequestViewModelProtocol: MovieRequestViewModelInput, MovieRequestViewModelOutput {}

class MovieRequestViewModel: MovieRequestViewModelProtocol {
    
    private var currentStatus: MovieRequestStatus = .initial {
        didSet {
            statusUpdateObservable.value = currentStatus
        }
    }
    private var statusUpdateObservable: Observable<MovieRequestStatus> = .init(.initial)
    private var queryTextObservable: Observable<String> = .init("")
    
    private let movieListRequestUseCase: RequestMovieListUseCaseProtocol
    private let resultsSetter: MovieListDataSetterProtocol
    
    init(movieListRequestUseCase: RequestMovieListUseCaseProtocol,
         resultsSetter: MovieListDataSetterProtocol) {
        self.movieListRequestUseCase = movieListRequestUseCase
        self.resultsSetter = resultsSetter
    }

    // MARK: - MovieRequestViewModelInput
    func initialize() {
        currentStatus = .initial
    }
    
    func requested(_ request: String) {
        queryTextObservable.value = request
        currentStatus = .loading
        
        movieListRequestUseCase.request(for: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetch):
                
                switch fetch {
                case .cache(let movies, let fetchDate, let error): fallthrough
                case .server(let movies):
                    self.resultsSetter.setData(movies)
                    self.currentStatus = movies.isEmpty ? .emptyResults : .results
                }
            case .failure(let error):
                break
            }
        }
    }

    // MARK: - MovieRequestViewModelOutput
    var statusUpdate: Observable<MovieRequestStatus> { statusUpdateObservable }
    var queryText: Observable<String> { queryTextObservable }
}
