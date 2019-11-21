//
//  SelectParkingTypeViewController.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/20/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class SelectParkingTypeViewController: UIViewController {
    var coordinator: Coordinator?
    var lot: Lot?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Parking Lot"
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        print(lot?.name)
    }
    


}
