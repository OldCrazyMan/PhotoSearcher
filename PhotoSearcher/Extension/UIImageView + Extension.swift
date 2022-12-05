//
//  UIImageView + Extension.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

extension UIImageView {
    func downloadImageWith(imageCache: NSCache<AnyObject, AnyObject>, urlString: String, completion: @escaping () -> Void) {

        mainThread {
            self.contentMode = .scaleToFill
        }
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            completion()
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                
                mainThread {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    completion()
                }
            }.resume()
        }
    }
}
