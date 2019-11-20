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
// and guidance from a previous iOS developer internship
protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController! {get set}
    
    func start()
}
