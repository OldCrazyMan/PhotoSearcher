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
    
    private let titleLabel = UILabel(text: "",
                                     font: UIFont.boldSystemFont(ofSize: 20),
                                     color: .specialLabel,
                                     line: 3)
    
    private var item: Items? = nil
    private var imageCache = NSCache<AnyObject, AnyObject>()
    
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
        view.addSubview(titleLabel)
        
        guard let item = item,
              let imageUrl = item.media?.m else { return }
        
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = item.title
        self.photoImageView.downloadImageWith(imageCache: imageCache, urlString: imageUrl) {}
    }
    
    func setItems(_ item: Items) {
        self.item = item
    }
}

//MARK: - SetConstraints

extension DetailsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
}
