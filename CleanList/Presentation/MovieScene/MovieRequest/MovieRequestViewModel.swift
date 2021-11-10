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
    case retry
}

protocol MovieRequestViewModelInput: AnyObject {
    func initialize()
    func requested(_ request: String)
    func requestStringCleared()
    func requestStringChanged(to string: String)
}

protocol MovieRequestViewModelOutput: AnyObject {
    var statusUpdate: Observable<MovieRequestStatus> { get }
    var queryText: Observable<String> { get }
    var infoMessage: Observable<String?> { get }
    var errorMessage: Observable<String?> { get }
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
    private var infoMessageObservable: Observable<String?> = .init("")
    private var errorMessageObservable: Observable<String?> = .init("")

    private let movieListRequestUseCase: RequestMovieListUseCaseProtocol
    private let resultsSetter: MovieListDataSetterProtocol
    
    private let cacheDateFormatter: DateFormatter = {
        let obj = DateFormatter()
        obj.dateFormat = "dd/MM/yyyy HH:mm"
        return obj
    }()
    
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
                case .cache(let movies, let fetchDate, _):
                    let cacheDateString = self.cacheDateFormatter.string(from: fetchDate)
                    self.infoMessage.value = "Показаны данные из кэша за " + cacheDateString
                    fallthrough
                case .server(let movies):
                    self.resultsSetter.setData(movies)
                    self.currentStatus = movies.isEmpty ? .emptyResults : .results
                }
            case .failure(let error):
                if let error = error as? NetworkServiceError,
                   case .cancelled = error {
                    // do nothing
                    return
                }
                
                self.currentStatus = .retry
            }
        }
    }
    
    func requestStringCleared() {
        movieListRequestUseCase.cancelCurrentRequestIfAny()
    }
    
    func requestStringChanged(to string: String) {
        movieListRequestUseCase.cancelCurrentRequestIfAny()
    }


    // MARK: - MovieRequestViewModelOutput
    var statusUpdate: Observable<MovieRequestStatus> { statusUpdateObservable }
    var queryText: Observable<String> { queryTextObservable }
    var infoMessage: Observable<String?> { infoMessageObservable }
    var errorMessage: Observable<String?> { errorMessageObservable }
}
