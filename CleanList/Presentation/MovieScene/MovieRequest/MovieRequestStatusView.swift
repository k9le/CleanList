//
//  MovieRequestStatusView.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

class MovieRequestStatusView: UIView {
    
    var status: MovieRequestStatus = .initial {
        didSet {
            noResultsLabel.isHidden = true
            makeLabel.isHidden = true
            activityIndicator.isHidden = true
            retryButton.isHidden = true
            
            switch status {
            case .initial:
                makeLabel.isHidden = false
            case .emptyResults:
                noResultsLabel.isHidden = false
            case .loading:
                activityIndicator.isHidden = false
            case .retry:
                retryButton.isHidden = false
            case .results: break
            }
        }
    }
    
    private let noResultsLabel: UILabel = {
        let obj = UILabel()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.text = "No results"
        return obj
    }()

    private let makeLabel: UILabel = {
        let obj = UILabel()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.text = "No query requested"
        return obj
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.startAnimating()
        return obj
    }()

    private let retryButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.setTitle("Retry", for: .normal)
        obj.setTitleColor(.lightGray, for: .normal)
        obj.layer.cornerRadius = 5.0
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.lightGray.cgColor
        return obj
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [noResultsLabel, makeLabel, activityIndicator, retryButton].forEach {
            addSubview($0)
            
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
        
        NSLayoutConstraint.activate([
            retryButton.widthAnchor.constraint(equalToConstant: 60),
            retryButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        status = .initial
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



