//
//  RequestMovieListUseCase.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation

protocol Cancellable {
    func cancel()
}

protocol RequestMovieListUseCaseProtocol {
    func request(for query: String, completion: @escaping ((Result<MovieFetchResult, Error>) -> Void))
}

class RequestMovieListUseCase: RequestMovieListUseCaseProtocol {
    
    let queryRepositorySaver: QueryPersistentStorageSaveProtocol
    let moviesRepository: MoviesRepositoryProtocol
    
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
        
        moviesRepository.fetchMovies(for: query) { result in 
            completion(result)
        }
        // вернуть Cancellable
    }

}
