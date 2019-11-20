//
//  SelectLotViewController.swift
//  CornellParking
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class SelectLotViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var background: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        background = UIView()
        background.backgroundColor = .white
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        
        title = "Recipes"
        // Do any additional setup after loading the view.
        
        setupConstraints()
    }
    

    func setupConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            background.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
