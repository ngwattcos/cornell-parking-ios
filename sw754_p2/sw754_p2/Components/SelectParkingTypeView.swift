//
//  SelectParkingTypeView.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/21/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit
import SnapKit

enum ParkingType: String {
    case general = "general"
    case accessible = "accessible"
    case eco = "eco"
}

class SelectParkingTypeView: UIView {
    
    var containerView: UIView!
    var verticalBar: UIView!
    var typeLabel: UILabel!
    var icon: UIImageView!
    var capacityLabel: UILabel!
    
    var padding = 10
    var cornerRadius: CGFloat = 10

    init(type: ParkingType, filled: Int, capacity: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        
        containerView = UIView()
        switch type {
        case .general:
            containerView.backgroundColor = .systemYellow
        case .accessible:
            containerView.backgroundColor = .systemBlue
//            containerView.backgroundColor = UIColor(red: CGFloat(0.31), green: CGFloat(0.86), blue: CGFloat(0.19), alpha: CGFloat(1.0))
        case .eco:
            containerView.backgroundColor = UIColor(red: CGFloat(0.31), green: CGFloat(0.86), blue: CGFloat(0.19), alpha: CGFloat(1.0))
            
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        
        verticalBar = UIView()
        verticalBar.translatesAutoresizingMaskIntoConstraints = false
        verticalBar.backgroundColor = .black
        containerView.addSubview(verticalBar)
        
        typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.text = type.rawValue
        typeLabel.textAlignment = .center
        containerView.addSubview(typeLabel)
        
        icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named: getImage(type: type))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(icon)
        
        capacityLabel = UILabel()
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.text = "\(filled)/\(capacity)"
        containerView.addSubview(capacityLabel)
        
        setupConstraints()
        
    }
    
    func getImage(type: ParkingType) -> String {
        return "type_\(type.rawValue)_gray"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {

        containerView.snp.makeConstraints ({ (make) -> Void in
            make.edges.equalToSuperview()
        })
        
        typeLabel.snp.makeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerY.equalTo(containerView.snp.centerY)
        })

        verticalBar.snp.makeConstraints({ make in
            make.width.equalTo(3)
            make.height.equalTo(containerView.snp.height).inset(20)
            make.leading.equalTo(typeLabel.snp.trailing)
            make.centerY.equalToSuperview()
        })
        
        icon.snp.makeConstraints({ make in
            make.leading.equalTo(verticalBar.snp.trailing).offset(20)
//            make.trailing.equalTo(containerView.snp.trailing)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(typeLabel.snp.top)
        })
        
        capacityLabel.snp.makeConstraints({ make in
            make.leading.equalTo(verticalBar.snp.trailing).offset(20)
//            make.centerX.equalTo(icon.snp.centerX)
            make.top.equalTo(icon.snp.bottom)
            make.bottom.equalTo(typeLabel.snp.bottom)
        })
    }
}
