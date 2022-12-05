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
        detailVC.setItems(item)
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }

        viewControoler?.present(detailVC, animated: true, completion: nil)
    }
}
