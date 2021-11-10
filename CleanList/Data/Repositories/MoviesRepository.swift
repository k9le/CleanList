//
//  MoviesRepository.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation

enum MovieFetchResult {
    case server([MovieListItem])
    case cache([MovieListItem], Date, Error?)
}

protocol MoviesRepositoryProtocol {
    func fetchMovies(for query: String, completion: @escaping ((Result<MovieFetchResult, Error>) -> Void)) -> Cancellable
}

class MoviesRepository: MoviesRepositoryProtocol {
    
    let moviesPersistentStorage: MoviesPersistentStorageProtocol
    let moviesDataProvider: MoviesDataProviderProtocol
    let queryCache: QueryPersistentStorageCacheProtocol

    init(persistentStorage: MoviesPersistentStorageProtocol,
         dataProvider: MoviesDataProviderProtocol,
         queryCache: QueryPersistentStorageCacheProtocol) {
        self.moviesPersistentStorage = persistentStorage
        self.moviesDataProvider = dataProvider
        self.queryCache = queryCache
    }

    func fetchMovies(for query: String, completion: @escaping ((Result<MovieFetchResult, Error>) -> Void)) -> Cancellable
    {

        moviesDataProvider.fetchMovies(for: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let resultArray):
                do {
                    let fetch = try self.moviesPersistentStorage.saveFetchResults(resultArray)
                    try self.queryCache.cacheFetchResult(fetch, for: query)
                } catch {
                    print("__ERR: error saving fetch results: \(error)")
                }

                completion(.success(.server(resultArray)))
                
            case .failure(let error):
                
                if case .cancelled = error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    if let cacheFetch = try self.queryCache.fetchCacheIfAny(for: query) {
                        completion(.success(.cache(cacheFetch.movies, cacheFetch.fetchedAt, error)))
                    } else {
                        completion(.failure(error))
                    }
                } catch {
                    print("__ERR: error fetching cache results: \(error)")
                }
                
            }
        }
    }

}

