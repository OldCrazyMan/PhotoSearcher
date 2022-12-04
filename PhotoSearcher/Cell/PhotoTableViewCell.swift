//
//  PhotoTableViewCell.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

final class PhotoTableViewCell: UITableViewCell {
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "NoImage")
        imageView.clipsToBounds = true
        imageView.alpha = 1
        imageView.layer.borderWidth = 1.2
        imageView.layer.borderColor = UIColor.specialLabel.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let namePhotoLabel = UILabel(text: "namePhotoLabel",
                                     font: UIFont.boldSystemFont(ofSize: 16),
                                     color: .specialLabel,
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
    
    //MARK: - Override
    
    override func prepareForReuse() {
        characterImageView.image = UIImage(named: "NoImage")
        characterImageView.alpha = 0.3
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
        addSubview(characterImageView)
        addSubview(labelsStackView)
    }
    
    //MARK: - ConfigureCell
    
    func cellConfigure() {
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            characterImageView.heightAnchor.constraint(equalToConstant: 120),
            characterImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
