//
//  MovieRequestRootView.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

class MovieRequestRootView: UIView {
    
    let statusView: MovieRequestStatusView = {
        let obj = MovieRequestStatusView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let searchBarContainerView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    let resultsTableContainerView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    let queryListContainerView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    let searchBar: UISearchBar = {
        let obj = UISearchBar()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(statusView)
        addSubview(resultsTableContainerView)
        addSubview(searchBarContainerView)
        addSubview(queryListContainerView)
        
        NSLayoutConstraint.activate([
            searchBarContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBarContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBarContainerView.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        [resultsTableContainerView, queryListContainerView, statusView].forEach {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        }
        
        searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchBarContainerView.addSubview(searchBar)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




