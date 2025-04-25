//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 16.04.25.
//

import Foundation

struct MostPopularMovies: Decodable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Decodable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL:  URL {
        let stringURL = imageURL.absoluteString
        let stringImageURL = stringURL.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: stringImageURL) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}

