//
//  ItemViewCell.swift
//  sw754_p2
//
//  Created by Scott Wang on 10/6/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell {
    
    var item: GroceryItem = GroceryItem(name: "", amount: 0)
    
    var nameLabel: UILabel!
    var amountLabel: UILabel!
    
    let cellView: UIView! = {
        let v = UIView()
        v.backgroundColor = .white
        
        return v
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
//        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(cellView)
        
        
        nameLabel = UILabel()
        amountLabel = UILabel()
        
        addSubview(nameLabel)
        addSubview(amountLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.leftAnchor.constraint(equalTo: leftAnchor),
            cellView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
    }
    
    func update(_ val: GroceryItem) {
        item = val
        
        
        nameLabel.text = item.name
        amountLabel.text = String(item.amount)
        
    }

}
