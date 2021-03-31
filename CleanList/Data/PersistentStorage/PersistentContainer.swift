//
//  PersistentContainer.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 18.03.2021.
//

import Foundation
import CoreData

enum PersistentStoreError: Error {
    case saveError(Error)
    case extractError(Error)
}


class PersistentContainer {
    
    private static var container: NSPersistentContainer?
    
    private static func createContainer() -> NSPersistentContainer {

        let containerName = "CleanList"
        let container = NSPersistentContainer(name: containerName)
        
        container.loadPersistentStores(completionHandler: {  (storeDescription, error) in
            if let error = error {
                fatalError("Error of loading persistentStore \"\(containerName)\": \(error)")
            }
        })
        return container
    }
    
    static var shared: NSPersistentContainer {
        if let container = Self.container { return container }
        
        Self.container = Self.createContainer()
        return Self.container!
    }

}

extension NSPersistentContainer {
    
    func saveContext() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
}
