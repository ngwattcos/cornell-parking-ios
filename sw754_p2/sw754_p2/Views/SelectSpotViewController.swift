//
//  SelectSpotViewController.swift
//  sw754_p2
//
//  Created by Scott Wang on 12/8/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit
import SnapKit

class SelectSpotViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    var typeId: Int?
    
    var padding: CGFloat = 0
    var paddingLeft: CGFloat = 20
    
    var spots: [Spot] = []
    
    
    var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    
    let spotCellReuseIdentifier = "spotCellReuseIdentifier"
    let headerReuseIdentifier = "headerReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Parking Spot"
        
        
        view.backgroundColor = .white
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LotCollectionViewCell.self, forCellWithReuseIdentifier: spotCellReuseIdentifier)
        view.addSubview(collectionView)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(loadSpots), for: .valueChanged)
    }
    
    @objc func loadSpots() {
        
    }

}

extension SelectSpotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: spotCellReuseIdentifier, for: indexPath) as! SpotViewCell
        
        cell.configure(for: spots[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    
}


extension SelectSpotViewController: UICollectionViewDelegateFlowLayout {
    
}

extension SelectSpotViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let spot = spots[indexPath.row]
        coordinator?.selectSpot(spot: spot)
    }
}
