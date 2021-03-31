//
//  MovieListItem.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 15.03.2021.
//

import Foundation

struct MovieListItem: Decodable {
    let title: String
    let description: String
    let releaseDate: String
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "overview"
        case releaseDate = "release_date"
        case imageURL = "poster_path"
    }
    
}
