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
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController!
    
    init(with navigationController: UINavigationController!) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let vc = SelectLotViewController()
        navigationController.pushViewController(vc, animated: false)
    }
}
