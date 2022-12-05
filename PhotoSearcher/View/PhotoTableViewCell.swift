//
//  PhotoTableViewCell.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

final class PhotoTableViewCell: UITableViewCell {
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.alpha = 1
        imageView.layer.borderWidth = 1.4
        imageView.layer.borderColor = UIColor.specialLabel.cgColor
        imageView.applyShadow(cornerRadius: 3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let namePhotoLabel = UILabel(text: "namePhotoLabel",
                                         font: UIFont.boldSystemFont(ofSize: 18),
                                         color: .white,
                                         line: 2)
    
    private let dataLabel = UILabel(text: "dataLabel",
                                    font: UIFont.systemFont(ofSize: 14),
                                    color: .specialLabel,
                                    line: 1)
    
    private let tagsLabel = UILabel(text: "tagsLabel",
                                    font: UIFont.systemFont(ofSize: 14),
                                    color: .specialLabel,
                                    line: 2)

    private var labelsStackView = UIStackView()
    private var imageCache = NSCache<AnyObject, AnyObject>()
    
    
    //MARK: - Override
    
    override func prepareForReuse() {
     //   photoImageView.image = UIImage(named: "NoImage")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        backgroundColor = .specialCellBackground
        selectionStyle = .none
        
        labelsStackView =  UIStackView(arrangedSubviews: [namePhotoLabel,
                                                          dataLabel,
                                                          tagsLabel],
                                       axis: .vertical,
                                       spacing: 2)
        addSubview(photoImageView)
        addSubview(labelsStackView)
    }
    
    //MARK: - ConfigureCell
    
    func cellConfigure(_ item: Items) {
        photoImageView.isHidden = true
        
        guard
            let title = item.title,
            let date = item.published,
            let tags = item.tags,
            let imageUrl = item.media?.m
        else { return }
        
        self.namePhotoLabel.text = "Title: \(title)"
        self.dataLabel.text = "Publication date: \(date.returnHumanReadableDate())"
        self.tagsLabel.text = "Tags: \(tags)"
        self.photoImageView.downloadImageWith(imageCache: imageCache, urlString: imageUrl) {
            DispatchQueue.main.async { [weak self] in
                self?.photoImageView.isHidden = false
            }
        }
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photoImageView.heightAnchor.constraint(equalToConstant: 120),
            photoImageView.widthAnchor.constraint(equalToConstant: 120),
            
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
