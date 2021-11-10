//
//  QueryPersistentStorage.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation
import CoreData

struct MoviesFetchItem {
    let movies: [MovieListItem]
    let fetchedAt: Date
    
    init?(with entity: MoviesFetchEntity) {
        guard let movies = entity.movies?.allObjects as? [MovieEntity],
              let fetchedAt = entity.fetchedAt else { return nil }
        
        self.movies = movies.compactMap { $0.item() }
        self.fetchedAt = fetchedAt
    }
}

protocol QueryPersistentStorageSaveProtocol {
    func saveQuery(_ query: String) throws
}

protocol QueryPersistentStorageExtractProtocol {
    func getQueries(with limit: Int?) throws -> [String]
}

protocol QueryPersistentStorageCacheProtocol {
    func cacheFetchResult(_ fetch: MoviesFetchEntity, for queryString: String) throws
    func fetchCacheIfAny(for queryString: String) throws -> MoviesFetchItem?
}

protocol QueryPersistentStorageProtocol: QueryPersistentStorageSaveProtocol, QueryPersistentStorageExtractProtocol, QueryPersistentStorageCacheProtocol { }

class QueryPersistentStorage: QueryPersistentStorageProtocol {
    
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    private var newEntity: QueryEntity {
        return NSEntityDescription.insertNewObject(
            forEntityName: "QueryEntity",
            into: persistentContainer.viewContext
        ) as! QueryEntity
    }
    
    private func existingEntity(with query: String) -> QueryEntity? {
        let fetchRequest = NSFetchRequest<QueryEntity>(entityName: "QueryEntity")
        fetchRequest.predicate = NSPredicate(format: "queryString == %@", query)
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            return nil
        }

    }
    
    // MARK: - QueryPersistentStorageSaveProtocol
    func saveQuery(_ query: String) throws {
        
        let queryEntity = existingEntity(with: query) ?? newEntity
            
        queryEntity.queryString = query
        queryEntity.createdAt = Date()
        
        do {
            try persistentContainer.saveContext()
        } catch {
            throw PersistentStoreError.saveError(error)
        }
    }

    // MARK: - QueryPersistentStorageExtractProtocol
    func getQueries(with limit: Int?) throws -> [String] {
        let fetchRequest = NSFetchRequest<QueryEntity>(entityName: "QueryEntity")
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        let sortByDate = NSSortDescriptor(keyPath: \QueryEntity.createdAt, ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            return results.compactMap { $0.queryString }
        } catch {
            throw PersistentStoreError.extractError(error)
        }
    }
    
    // MARK: - QueryPersistentStorageCacheProtocol
    func cacheFetchResult(_ fetch: MoviesFetchEntity, for queryString: String) throws {
        guard let queryItem = try fetchQueryItemIfAny(for: queryString) else { return }

        if let queryFetch = queryItem.queryFetch {
            persistentContainer.viewContext.delete(queryFetch)
        }
        queryItem.queryFetch = fetch
        do {
            try persistentContainer.saveContext()
        } catch {
            throw PersistentStoreError.saveError(error)
        }
    }
    
    func fetchCacheIfAny(for queryString: String) throws -> MoviesFetchItem? {
        guard let fetchEntity = try fetchQueryItemIfAny(for: queryString)?.queryFetch else {
            return nil
        }
        
        return MoviesFetchItem(with: fetchEntity)
    }
    
    private func fetchQueryItemIfAny(for queryString: String) throws -> QueryEntity? {
        let fetchRequest = NSFetchRequest<QueryEntity>(entityName: "QueryEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "queryString == %@", queryString)

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            throw PersistentStoreError.extractError(error)
        }
    }

}



