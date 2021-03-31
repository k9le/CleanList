//
//  MovieImageDataProvider.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 26.03.2021.
//

import Foundation

protocol MovieImageDataProviderProtocol {
    func fetchImage(for id: String, completion: @escaping ((Result<Data, NetworkServiceError>) -> Void))
}


class MovieImageDataProvider: MovieImageDataProviderProtocol {

    let networkService: RequestDataNetworkServiceProtocol

    init(networkService: RequestDataNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchImage(for id: String, completion: @escaping ((Result<Data, NetworkServiceError>) -> Void)) {

        let urlString = "http://image.tmdb.org/t/p/w185" + id
        let url = URL(string: urlString)!
        
        let urlRequest = URLRequest(url: url)
        
        networkService.requestData(with: urlRequest, completion: completion)
    }

}
