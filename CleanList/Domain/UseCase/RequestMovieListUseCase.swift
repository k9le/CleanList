//
//  RequestMovieListUseCase.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation

protocol RequestMovieListUseCaseProtocol {
    func request(for query: String, completion: @escaping ((Result<MovieFetchResult, Error>) -> Void))
    func cancelCurrentRequestIfAny()
}

class RequestMovieListUseCase: RequestMovieListUseCaseProtocol {
    
    private let queryRepositorySaver: QueryPersistentStorageSaveProtocol
    private let moviesRepository: MoviesRepositoryProtocol
    
    private var currentRequest: Cancellable?
    
    init(querySaver: QueryPersistentStorageSaveProtocol,
         moviesRepository: MoviesRepositoryProtocol) {
        self.queryRepositorySaver = querySaver
        self.moviesRepository = moviesRepository
    }
    
    // MARK: - RequestMovieListUseCaseProtocol
    func request(for query: String, completion: @escaping ((Result<MovieFetchResult, Error>) -> Void)) {
        do {
            try queryRepositorySaver.saveQuery(query)
        } catch {
            print("")
        }
        
        currentRequest = moviesRepository.fetchMovies(for: query) { [weak self] result in
            completion(result)
            self?.currentRequest = nil
        }
    }
    
    func cancelCurrentRequestIfAny() {
        currentRequest?.cancel()
    }

}
