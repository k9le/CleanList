//
//  QueryEntity+CoreDataProperties.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 22.03.2021.
//
//

import Foundation
import CoreData


extension QueryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QueryEntity> {
        return NSFetchRequest<QueryEntity>(entityName: "QueryEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var queryString: String?
    @NSManaged public var queryFetch: MoviesFetchEntity?

}

extension QueryEntity : Identifiable {

}
