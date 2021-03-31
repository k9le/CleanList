//
//  MoviesPersistentStorage.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation
import CoreData

protocol MoviesPersistentStorageProtocol {
    func saveFetchResults(_ results: [MovieListItem]) throws -> MoviesFetchEntity
}

class MoviesPersistentStorage: MoviesPersistentStorageProtocol {

    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    private var newFetchEntity: MoviesFetchEntity {
        return NSEntityDescription.insertNewObject(
            forEntityName: "MoviesFetchEntity",
            into: persistentContainer.viewContext
        ) as! MoviesFetchEntity
    }

    private var newMovieEntity: MovieEntity {
        return NSEntityDescription.insertNewObject(
            forEntityName: "MovieEntity",
            into: persistentContainer.viewContext
        ) as! MovieEntity
    }

    func saveFetchResults(_ results: [MovieListItem]) throws -> MoviesFetchEntity {
        let newFetch = newFetchEntity
        newFetch.fetchedAt = Date()
        
        for item in results {
            let newMovie = newMovieEntity
            newMovie.fill(with: item)
            newFetch.addToMovies(newMovie)
        }
        
        do {
            try persistentContainer.saveContext()
            return newFetch
        } catch {
            throw PersistentStoreError.saveError(error)
        }
        
    }

}
