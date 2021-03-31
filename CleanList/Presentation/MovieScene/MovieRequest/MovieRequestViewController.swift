//
//  MovieRequestViewController.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 13.03.2021.
//

import UIKit

class MovieRequestViewController: UIViewController {
    
    private var statusView: MovieRequestStatusView { rootView.statusView }
    private var searchBar: UISearchBar { rootView.searchBar }
    
    private var rootView: MovieRequestRootView {
        return view as! MovieRequestRootView
    }

    private var queryListDemonstrator: ContainerDemonstrator?
    private var resultsListDemonstrator: ContainerDemonstrator?

    var viewModel: MovieRequestViewModelProtocol? {
        didSet { bindViewModel() }
    }
    
    var queryListFactory: ControllerFactory? {
        didSet {
            guard let queryListFactory = queryListFactory else {
                queryListDemonstrator = nil
                return
            }
            
            queryListDemonstrator = ContainerDemonstrator(
                with: queryListFactory,
                container: rootView.queryListContainerView,
                parent: self
            )
        }
    }
    
    var resultsListFactory: MovieListFactoryProtocol? {
        didSet {
            guard let resultsListFactory = resultsListFactory else {
                resultsListDemonstrator = nil
                return
            }
            
            resultsListDemonstrator = ContainerDemonstrator(
                with: resultsListFactory,
                container: rootView.resultsTableContainerView,
                parent: self
            )
        }
    }
    
}

// MARK: - Lifecycle
extension MovieRequestViewController {
    
    override func loadView() {
        self.view = MovieRequestRootView()
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.initialize()
    }
}

private extension MovieRequestViewController {
    
    func bindViewModel() {
        viewModel?.statusUpdate.observe(on: self, observerBlock: statusUpdate(_:))
        viewModel?.queryText.observe(on: self) { [weak self] queryText in
            self?.searchBar.text = queryText
        }
    }
    
    func statusUpdate(_ status: MovieRequestStatus) {
        searchBar.endEditing(true)
        
        queryListDemonstrator?.remove()
        resultsListDemonstrator?.remove()

        switch status {
        case .loading: fallthrough
        case .emptyResults: fallthrough
        case .initial:
            statusView.status = status
        case .results:
            resultsListDemonstrator?.insert()
        }
    }
}

extension MovieRequestViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        queryListDemonstrator?.insert()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        queryListDemonstrator?.remove()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel?.requested(query)
    }
}
