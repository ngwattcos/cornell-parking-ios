//
//  LotCollectionViewCell.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class LotCollectionViewCell: UICollectionViewCell {
    var paddingLeft: CGFloat = 5
    var paddingOffset: CGFloat = 20
    var nameLabel: UILabel!
    var backgroundImageView: UIImageView!
    
    var colors = ["blue", "red", "yellow", "green", "orange"]
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundImageView = UIImageView()
        nameLabel = UILabel()
        
        
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.backgroundColor = .systemYellow
        contentView.addSubview(backgroundImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.adjustsFontSizeToFitWidth = false
        nameLabel.font = .boldSystemFont(ofSize: 25)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for lot: Lot, index: Int) {
        nameLabel.text = lot.name
        
        let color = colors[((index % colors.count) + colors.count) % colors.count]
        let imageName: String = "parking_\(lot.location.rawValue)_\(color)"
        
        backgroundImageView.image = UIImage(named: imageName)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingOffset),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeft),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            
        ])
    }
}
