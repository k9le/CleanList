//
//  Cancellable.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 06.04.2021.
//

import Foundation

protocol Cancellable {
    func cancel()
}


extension URLSessionTask: Cancellable {}
