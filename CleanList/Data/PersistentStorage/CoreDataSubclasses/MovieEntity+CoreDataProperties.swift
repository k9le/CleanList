//
//  MovieEntity+CoreDataProperties.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 22.03.2021.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var descr: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var imageURL: String?

}

extension MovieEntity : Identifiable {

}
