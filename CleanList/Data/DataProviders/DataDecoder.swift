//
//  DataDecoderProtocol.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 18.03.2021.
//

import Foundation

protocol DataDecoderProtocol {
    func decode<T: Decodable>(_ type: T.Type, fromData data: Data) -> Result<T, Error>
}


extension JSONDecoder: DataDecoderProtocol {
    
    func decode<T>(_ type: T.Type, fromData data: Data) -> Result<T, Error> where T : Decodable {
        do {
            let decoded = try decode(type, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
