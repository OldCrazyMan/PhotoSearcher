//
//  DetailsViewController.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.1646832824, green: 0.1647188365, blue: 0.1646810472, alpha: 1)
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addSubview(photoImageView)
    }
}

//MARK: - SetConstraints

extension DetailsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            photoImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
    }
}
