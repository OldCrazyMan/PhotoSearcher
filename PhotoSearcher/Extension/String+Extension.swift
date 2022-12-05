//
//  String+Extension.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import Foundation

extension String {
    
    func returnHumanReadableDate() -> Self {
        let isoDateFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        
        isoDateFormatter.formatOptions = [
            .withInternetDateTime,
        ]
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        guard let date = isoDateFormatter.date(from: self) else {
            return "No Date"
        }
        
        return dateFormatter.string(from: date)
    }
    
    func convertToDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
    
    static func returnFlickrUrlStringWithTag(_ tag: String) -> String {
        return "https://api.flickr.com/services/feeds/photos_public.gne?tags=\(tag)&tagmode=any&format=json&nojsoncallback=?"
    }
}
