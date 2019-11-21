//
//  Coordinator.swift
//  CornellParking
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit
import Foundation

// followed https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
// and some experience from a recent iOS developer internship
protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? {get set}
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController! {get set}
    
    func start()
}
