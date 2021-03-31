//
//  MovieListItemCell.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//

import UIKit

class MovieListItemCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.numberOfLines = 2
        obj.font = .systemFont(ofSize: 18, weight: .semibold)
        return obj
    }()
    
    private let descriptionLabel: UILabel = {
        let obj = UILabel()
        obj.numberOfLines = 0
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.font = .systemFont(ofSize: 14)
        obj.setContentCompressionResistancePriority(.init(100), for: .vertical)
        return obj
    }()

    private let releaseDateLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 14)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let movieImageView: UIImageView = {
        let obj = UIImageView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.contentMode = .scaleAspectFill
        obj.backgroundColor = .init(red: 245.0/256.0, green: 245.0/256.0, blue: 245.0/256.0, alpha: 1.0)
        return obj
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.tintColor = .white
        obj.startAnimating()
        return obj
    }()

    private let infoView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let imageContentView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    
    var viewModel: MovieListItemViewModelProtocol? {
        willSet {
            viewModel?.imageState.remove(observer: self)
        }
        
        didSet {
            bindViewModel()
        }
    }
    
    var updateBlock: (() -> Void)?
    
    private lazy var infoViewtToImageContentConstaint: NSLayoutConstraint = {
        let obj = infoView.trailingAnchor.constraint(equalTo: imageContentView.leadingAnchor)
        obj.priority = .defaultLow
        return obj
    }()
    
    private lazy var infoViewtToContentViewConstaint: NSLayoutConstraint = {
        let obj = infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        obj.priority = .init(rawValue: 999)
        return obj
    }()
    
    private lazy var movieImageBottomConstraint: NSLayoutConstraint = {
        let obj = movieImageView.bottomAnchor.constraint(lessThanOrEqualTo: imageContentView.bottomAnchor, constant: -5)
        obj.priority = .init(999)
        return obj
    }()
    
    private lazy var movieImageHeightConstaint: NSLayoutConstraint = {
        let obj = movieImageView.heightAnchor.constraint(equalToConstant: 175)
        obj.priority = .init(500)
        return obj
    }()
    
    private lazy var descriptionLabelBottomConstaint: NSLayoutConstraint = {
        let obj = descriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: movieImageView.bottomAnchor)
        obj.priority = .init(201)
        return obj
    }()

    private lazy var descriptionLabelHeightConstaint: NSLayoutConstraint = {
        let obj = descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 85)
        obj.priority = .init(200)
        return obj
    }()

    private func setImageHide(_ on: Bool) {
        infoViewtToImageContentConstaint.priority = on ? .defaultLow : .init(rawValue: 999)
        infoViewtToContentViewConstaint.priority = !on ? .defaultLow : .init(rawValue: 999)
        setNeedsLayout()
        imageContentView.isHidden = on
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviewsAndLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupSubviewsAndLayout() {
        
        contentView.addSubview(imageContentView)
        contentView.addSubview(infoView)

        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoViewtToImageContentConstaint,
            infoViewtToContentViewConstaint,

            imageContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        infoView.addSubview(titleLabel)
        infoView.addSubview(releaseDateLabel)
        infoView.addSubview(descriptionLabel)
        imageContentView.addSubview(movieImageView)
        imageContentView.addSubview(activityIndicator)
        
        let infoLeading: CGFloat = 8
        let infoTrailing: CGFloat = -8
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: infoLeading),
            titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: releaseDateLabel.topAnchor, constant: -5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor, constant: infoTrailing),

            releaseDateLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: infoLeading),
            releaseDateLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -5),
            releaseDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor, constant: infoTrailing),

            descriptionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: infoLeading),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor, constant: -8),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor, constant: infoTrailing),
            descriptionLabelHeightConstaint,
            descriptionLabelBottomConstaint,
        ])

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: imageContentView.leadingAnchor, constant: 5),
            movieImageView.trailingAnchor.constraint(equalTo: imageContentView.trailingAnchor, constant: -5),
            movieImageView.topAnchor.constraint(equalTo: imageContentView.topAnchor, constant: 5),
            movieImageBottomConstraint,
            movieImageView.widthAnchor.constraint(equalToConstant: 175),
            movieImageHeightConstaint,
            
            activityIndicator.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: movieImageView.centerXAnchor),
        ])
    }
    
    
    private func bindViewModel() {
        titleLabel.text = viewModel?.title

        if let description = viewModel?.description {
            descriptionLabel.text = "Description: \(description)"
        } else {
            descriptionLabel.text = nil
        }

        if let releaseDate = viewModel?.releaseDate {
            releaseDateLabel.text = "Release date: \(releaseDate)"
        } else {
            releaseDateLabel.text = nil
        }
        
        viewModel?.imageState.observe(on: self) { [weak self] state in
            guard let self = self else { return }

            switch state {
            case .noImage:
                self.setImageHide(true)
                self.movieImageView.image = nil
                self.activityIndicator.isHidden = true
            case .loading:
                self.setImageHide(false)
                self.movieImageView.image = nil
                self.activityIndicator.isHidden = false
            case .image(let image):
                self.setImageHide(false)
                self.movieImageView.image = image
                self.activityIndicator.isHidden = true
                self.updateBlock?()
            }
        }
        
    }
}

