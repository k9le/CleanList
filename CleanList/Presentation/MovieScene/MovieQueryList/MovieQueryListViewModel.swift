//
//  MovieQueryListViewModel.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import Foundation

protocol MovieQueryListViewModelInput: AnyObject {
    func initialize()
    func didChoose(_ index: Int)
}

protocol MovieQueryListViewModelOutput: AnyObject {
    var listUpdate: Observable<[MovieQueryListItemViewModelProtocol]> { get }
}

protocol MovieQueryListViewModelProtocol: MovieQueryListViewModelInput, MovieQueryListViewModelOutput { }


class MovieQueryListViewModel: MovieQueryListViewModelProtocol {

    private var queries: [String] = []
    
    private var queryExtractor: QueryPersistentStorageExtractProtocol

    private var listUpdateObservable: Observable<[MovieQueryListItemViewModelProtocol]> = .init([])
    
    private var requestedFunc: RequestedClosure?
    
    init(with requestedFunc: @escaping RequestedClosure,
         queryExtractor: QueryPersistentStorageExtractProtocol) {
        self.requestedFunc = requestedFunc
        self.queryExtractor = queryExtractor
    }

    // MARK: - MovieQueryListViewModelInput
    func initialize() {
        do {
            queries = try queryExtractor.getQueries(with: nil)
            listUpdateObservable.value = queries.map { MovieQueryListItemViewModel(queryString: $0) }
        } catch {
            print("error")
        }
    }
    
    func didChoose(_ index: Int) {
        requestedFunc?(queries[index])
    }
    
    // MARK: - MovieQueryListViewModelOutput
    var listUpdate: Observable<[MovieQueryListItemViewModelProtocol]> { listUpdateObservable
    }

}
