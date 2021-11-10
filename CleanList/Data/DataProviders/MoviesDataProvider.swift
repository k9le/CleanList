//
//  MoviesDataProvider.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation

protocol MoviesDataProviderProtocol {
    func fetchMovies(for query: String, completion: @escaping ((Result<[MovieListItem], NetworkServiceError>) -> Void)) -> Cancellable
}


class MoviesDataProvider: MoviesDataProviderProtocol {

    let networkService: RequestDecodableNetworkServiceProtocol

    init(networkService: RequestDecodableNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchMovies(for query: String, completion: @escaping ((Result<[MovieListItem], NetworkServiceError>) -> Void)) -> Cancellable {

        let urlString = "https://www.myapifilms.com/tmdb/searchMovie"
        let url = URL(string: urlString)

        let params =  [
            "token": "a11e758d-917e-4aad-91b5-b254114b62f7",
            "language": "en",
            "format": "json",
            "movieName": query,
        ]
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        let queryURL = urlComponents.url(relativeTo: url)!
        return networkService.request(ResponseData.self,
                               urlRequest: URLRequest(url: queryURL)) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let responseResult):
                completion(.success(responseResult.data.results))
            }
        }
    }

}


private extension MoviesDataProvider {
    
    struct ResponseResults: Decodable {
        let results: [MovieListItem]
    }
    
    struct ResponseData: Decodable {
        let data: ResponseResults
    }
}
