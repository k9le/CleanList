//
//  DataProviderProtocol.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 18.03.2021.
//

import Foundation

enum NetworkServiceError: Error {
    case emptyDataResponse
    case decodeError(Error)
    case networkError(Error)
}



protocol RequestDecodableNetworkServiceProtocol {
    typealias RequestDecodableCompletionBlock<T> = (Result<T, NetworkServiceError>) -> Void
    
    func request<T: Decodable>(_ type: T.Type,
                               urlRequest: URLRequest,
                               completion: @escaping RequestDecodableCompletionBlock<T>)
    
}

protocol RequestDataNetworkServiceProtocol {
    typealias RequestDataCompletionBlock = (Result<Data, NetworkServiceError>) -> Void
    
    func requestData(with urlRequest: URLRequest,
                     completion: @escaping RequestDataCompletionBlock)
}


class NetworkService {
    
    let session: URLSession
    let decoder: DataDecoderProtocol
    
    init(session: URLSession,
         decoder: DataDecoderProtocol) {
        self.session = session
        self.decoder = decoder
    }
    
}

extension NetworkService: RequestDecodableNetworkServiceProtocol {
    
    func request<T: Decodable>(_ type: T.Type,
                               urlRequest: URLRequest,
                               completion: @escaping RequestDecodableCompletionBlock<T>) {
        
        requestData(with: urlRequest) { result in
            
            if case .success(let data) = result {
                let decodeResult = self.decoder.decode(T.self, fromData: data)
                
                if case .success(let decodedData) = decodeResult {
                    completion(.success(decodedData))
                } else if case .failure(let error) = decodeResult {
                    completion(.failure(.decodeError(error)))
                }
            } else if case .failure(let error) = result {
                completion(.failure(error))
            }
        }
    }
    
}

extension NetworkService: RequestDataNetworkServiceProtocol {
    
    func requestData(with urlRequest: URLRequest,
                     completion: @escaping RequestDataCompletionBlock) {
        session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.emptyDataResponse))
                return
            }
            completion(.success(data))
        }
        .resume()
    }

}
