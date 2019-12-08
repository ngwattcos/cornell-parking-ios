//
//  SelectParkingTypeViewController.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/20/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit
import SnapKit

class SelectParkingTypeViewController: UIViewController {
    var coordinator: Coordinator?
    var lot: Lot?
    
    var generalView: UIView!
    var accessibleView: UIView!
    var ecoView: UIView!
    
    var parkingTypeAvailability: [LotAvailability] = []
    
    var tableView: UITableView!
    
    
    var padding = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Parking Type"
        // Do any additional setup after loading the view.
        
        generalView = SelectParkingTypeView(type: .general, filled: 0, capacity: 10)
        generalView.translatesAutoresizingMaskIntoConstraints = false
        accessibleView = SelectParkingTypeView(type: .accessible, filled: 0, capacity: 10)
        accessibleView.translatesAutoresizingMaskIntoConstraints = false
        ecoView = SelectParkingTypeView(type: .eco, filled: 0, capacity: 10)
        ecoView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.dataSource = self
//        tableView.delegate = self
        
        view.addSubview(generalView)
        view.addSubview(accessibleView)
        view.addSubview(ecoView)
        
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            accessibleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            accessibleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            accessibleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            accessibleView.heightAnchor.constraint(equalToConstant: CGFloat(100)),
//        ])
        accessibleView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
        })
        

        generalView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(accessibleView.snp.top).offset(-padding)
            make.height.equalTo(100)
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
        })

        ecoView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(accessibleView.snp.bottom).offset(padding)
            make.height.equalTo(100)
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
        })
    }

    func getParkingTypes() {
        NetworkManager.getParkingTypes({ types in
            self.parkingTypeAvailability.removeAll()
            
            for type in types {
                self.parkingTypeAvailability.append(LotAvailability(lotType: type))
            }
            
        })
    }
}


//extension SelectParkingTypeViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return parkingTypeAvailability.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//
//}
