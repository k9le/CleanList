//
//  MovieListItemViewModel.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//

import UIKit

enum ImageState {
    case noImage
    case loading
    case image(UIImage)
    case loadFailed
}

protocol MovieListItemViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var releaseDate: String { get }

    var imageState: Observable<ImageState> { get }
    
    func cancelLoadingImage()
}

class MovieListItemViewModel: MovieListItemViewModelProtocol {
    
    let title: String
    let description: String
    let releaseDate: String
    
    let imageState: Observable<ImageState>
    
    private var imageLoadingCancellable: Cancellable?
    
    init(with item: MovieListItem, imageDataProvider: MovieImageDataProviderProtocol) {
        title = item.title
        description = item.description
        releaseDate = item.releaseDate
        
        if let imageURL = item.imageURL {
            imageState = .init(.loading)
            
            imageLoadingCancellable = imageDataProvider.fetchImage(for: imageURL) { [weak self] result in
                guard let self = self else { return }
                
                if case .success(let data) = result, let image = UIImage(data: data) {
                    self.imageState.value = .image(image)
                } else {
                    self.imageState.value = .loadFailed
                }
            }
        } else {
            imageState = .init(.noImage)
        }
        
    }
    
    func cancelLoadingImage() {
        imageLoadingCancellable?.cancel()
    }

}
