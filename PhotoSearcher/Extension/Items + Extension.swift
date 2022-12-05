//
//  Items+Extension.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import Foundation

extension Items {
    func getDateNonOptionalFromPublished() -> Date {
        guard let published = self.published else { return Date() }
        return published.convertToDate()
    }
}
