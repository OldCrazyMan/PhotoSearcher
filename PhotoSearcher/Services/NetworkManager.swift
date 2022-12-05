//
//  NetworkManager.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import Foundation

class NetworkManager {
    
    var isPagination = false
    
    func makeRequest(tag: String, completion: @escaping (Result<[Items], NetworkError>) -> Void) {

        if let flickrURL = URL(string: String.returnFlickrUrlStringWithTag(tag)) {

            URLSession.shared.dataTask(with: flickrURL) { data, response, error in
                
                if error == nil {
                    do {
                        guard let data = data else {
                            completion(.failure(NetworkError.dataIsNil))
                            return
                        }
                        
                        let flickrItems = try JSONDecoder().decode(FlickrSearch.self, from: data)
                        
                        guard let items = flickrItems.items else {
                            completion(.failure(NetworkError.itemsIsNil))
                            return
                        }
                        
                        completion(.success(items))
                    } catch {
                        completion(.failure(NetworkError.wrongJsonFormat))
                    }
                } else {
                    completion(.failure(NetworkError.badUrl))
                }
            }.resume()
        }
    }
}
