//
//  SelectParkingTypeView.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/21/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit
import SnapKit

class SelectParkingTypeView: UIView {
    
    var containerView: UIView!
    var verticalBar: UIView!
    var typeLabel: UILabel!
    var icon: UIImageView!
    var capacityLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIView()
        addSubview(containerView)
        
        verticalBar = UIView()
        containerView.addSubview(verticalBar)
        
        typeLabel = UILabel()
        containerView.addSubview(typeLabel)
        
        icon = UIImageView()
        containerView.addSubview(icon)
        
        capacityLabel = UILabel()
        containerView.addSubview(capacityLabel)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for parkingType: ParkingType) {
        
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(superview!)
        }
    }
}
