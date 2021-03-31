//
//  MovieEntity+CoreDataClass.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 22.03.2021.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {

    func fill(with item: MovieListItem) {
        self.title = item.title
        self.descr = item.description
        self.releaseDate = item.releaseDate
        self.imageURL = item.imageURL
    }
    
    func item() -> MovieListItem? {
        guard let title = title,
              let description = descr,
              let releaseDate = releaseDate else {
            return nil
        }
        
        return MovieListItem(
            title: title,
            description: description,
            releaseDate: releaseDate,
            imageURL: imageURL
        )

    }
    
}
