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
    var coordinator: MainCoordinator?
    var lot: Lot?
    
    var tap0: UITapGestureRecognizer!
    var tap1: UITapGestureRecognizer!
    var tap2: UITapGestureRecognizer!
    
    var generalView: SelectParkingTypeView!
    var accessibleView: SelectParkingTypeView!
    var ecoView: SelectParkingTypeView!
    
//    let refreshControl = UIRefreshControl()
    
    var parkingTypeAvailability: [LotAvailability] = []
    
    var tableView: UITableView!
    
    
    var padding = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Parking Type"
        // Do any additional setup after loading the view.
        
        generalView = SelectParkingTypeView(type: .general, available: 0, capacity: 10)
        generalView.translatesAutoresizingMaskIntoConstraints = false
        accessibleView = SelectParkingTypeView(type: .accessible, available: 0, capacity: 10)
        accessibleView.translatesAutoresizingMaskIntoConstraints = false
        ecoView = SelectParkingTypeView(type: .eco, available: 0, capacity: 10)
        ecoView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tap0 = UITapGestureRecognizer(target: self, action: #selector(loadAccessible))
        tap1 = UITapGestureRecognizer(target: self, action: #selector(loadEco))
        tap2 = UITapGestureRecognizer(target: self, action: #selector(loadGeneral))
        
        accessibleView.addGestureRecognizer(tap0)
        accessibleView.isUserInteractionEnabled = true
        ecoView.addGestureRecognizer(tap1)
        ecoView.isUserInteractionEnabled = true
        generalView.addGestureRecognizer(tap2)
        generalView.isUserInteractionEnabled = true
        
        view.addSubview(generalView)
        view.addSubview(accessibleView)
        view.addSubview(ecoView)
        

        view.backgroundColor = .white
        
        
        loadAvailability()
        setupConstraints()
    }
    
    func setupConstraints() {
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

    @objc func loadAvailability() {
        print("potato?")
        NetworkManager.getParkingTypes(id: lot?.id ?? 1, { availability in
            
            DispatchQueue.main.async(execute: {
                let accessibleData = availability[0]
                let ecoData = availability[1]
                let generalData = availability[2]
                print("receiving data:\(accessibleData)\n\(ecoData)\n\(generalData)")
                self.accessibleView.update(available: accessibleData.availability, capacity: accessibleData.capacity)
                self.ecoView.update(available: ecoData.availability, capacity: ecoData.capacity)
                self.generalView.update(available: generalData.availability, capacity: generalData.capacity)
                
//                self.refreshControl.endRefreshing()
//                self.collectionView.reloadData()
            })
        })
        
    }
    
    @objc func loadGeneral() {
        coordinator?.selectParkingType(type: 2)
    }
    
    @objc func loadEco() {
        coordinator?.selectParkingType(type: 1)
    }
    
    @objc func loadAccessible() {
        coordinator?.selectParkingType(type: 0)
    }
}
