//
//  MovieQueryListFactory.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

typealias RequestedClosure = ((String) -> Void)

class MovieQueryListFactory: ControllerFactory {
    
    private var requestedFunc: RequestedClosure
    
    init(with requestedFunc: @escaping RequestedClosure) {
        self.requestedFunc = requestedFunc
    }
    
    func create() -> UIViewController {
        let queryRepository = QueryPersistentStorage(persistentContainer: PersistentContainer.shared)
        
        let vc = MovieQueryListViewController()
        vc.viewModel = MovieQueryListViewModel(
            with: requestedFunc,
            queryExtractor: queryRepository
        )
        
        return vc
    }
}
