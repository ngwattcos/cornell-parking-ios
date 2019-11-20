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
    var bottomBar: UIView!
    var bottomBox: UIView!
    
    var labelHeight: CGFloat = 50
    var bottomBarHeight: CGFloat = 40
    var labelPadding: CGFloat = 10
    
    var colors = ["blue", "red", "yellow", "green", "orange"]
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundImageView = UIImageView()
        nameLabel = UILabel()
        bottomBar = UIView()
        bottomBox = UIView()
        
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 5
        
        
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
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.layer.masksToBounds = false;
        bottomBar.backgroundColor = .white
        
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.backgroundColor = .white
        bottomBar.addSubview(bottomBox)
        
        contentView.addSubview(bottomBar)
        
        
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
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomBarHeight),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingOffset),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingLeft),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
        ])
        
        NSLayoutConstraint.activate([
            bottomBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomBar.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: bottomBarHeight),
            
        ])
        
        NSLayoutConstraint.activate([
            bottomBox.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor),
            bottomBox.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: labelPadding),
            bottomBox.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -labelPadding),
            bottomBox.heightAnchor.constraint(equalToConstant: labelHeight),
        ])
    }
}
