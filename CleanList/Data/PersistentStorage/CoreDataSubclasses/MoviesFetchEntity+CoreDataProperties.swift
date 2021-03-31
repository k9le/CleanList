//
//  MoviesFetchEntity+CoreDataProperties.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 23.03.2021.
//
//

import Foundation
import CoreData


extension MoviesFetchEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesFetchEntity> {
        return NSFetchRequest<MoviesFetchEntity>(entityName: "MoviesFetchEntity")
    }

    @NSManaged public var fetchedAt: Date?
    @NSManaged public var movies: NSSet?

}

// MARK: Generated accessors for movies
extension MoviesFetchEntity {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: MovieEntity)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: MovieEntity)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}

extension MoviesFetchEntity : Identifiable {

}
