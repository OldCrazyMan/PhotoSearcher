//
//  NetworkError.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import Foundation

enum NetworkError: String, Error {
    case badUrl = "Please check URL"
    case wrongJsonFormat = "Please check your JSON"
    case dataIsNil = "Data is nil"
    case itemsIsNil = "Array of items from flickr is nil"
}
