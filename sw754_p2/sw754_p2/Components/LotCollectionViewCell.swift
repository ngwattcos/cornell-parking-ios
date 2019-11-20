//
//  LotCollectionViewCell.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class LotCollectionViewCell: UICollectionViewCell {
    var backgroundImage: UIImageView
    
    override init(frame: CGRect) {
        
        backgroundImage = UIImageView()
        
        
        super.init(frame: frame)
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.layer.masksToBounds = true
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImage)
        
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
}
