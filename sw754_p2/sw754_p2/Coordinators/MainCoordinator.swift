//
//  MainCoordinator.swift
//  CornellParking
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//
import UIKit
import Foundation

class MainCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController!
    
    init(with navigationController: UINavigationController!) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let vc = SelectLotViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func displayParkingTypes(for lot: Lot) {
        let vc = SelectParkingTypeViewController()
        vc.lot = lot
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
