//
//  Coordinator.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

class Coordinator {
    var viewControoler: UIViewController?
    
    init(viewControoler: UIViewController?) {
        self.viewControoler = viewControoler
    }
    
    func showDetailViewController(for item: Items) {
        let detailVC = DetailsViewController()
        viewControoler?.present(detailVC, animated: true)
    }
}
