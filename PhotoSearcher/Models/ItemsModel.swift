//
//  ItemsModel.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import Foundation

struct Items: Codable {
    let title: String?
    let media: Media?
    let published: String?
    let tags: String?
}
