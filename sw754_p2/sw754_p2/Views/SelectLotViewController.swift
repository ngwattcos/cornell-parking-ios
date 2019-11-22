//
//  SelectLotViewController.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit
import SnapKit

class SelectLotViewController: UIViewController {
    var coordinator: MainCoordinator?
    var lot: Lot?
    var collectionView: UICollectionView!
    var background: UIView!
    var padding: CGFloat = 20
    var paddingSide: CGFloat = 20
    let headerHeight: CGFloat = 30
    
    let refreshControl = UIRefreshControl()
    
    
    let lotCellReuseIdentifier = "lotCellReuseIdentifier"
    let headerReuseIdentifier = "headerReuseIdentifier"
    
    var lots: [Lot]! = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Select Parking Lot"
        
       
        setupCollectionView()
        
        
        setupConstraints()
        loadLots()
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
        collectionView.register(LotCollectionViewCell.self, forCellWithReuseIdentifier: lotCellReuseIdentifier)
        view.addSubview(collectionView)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(loadLots), for: .valueChanged)
    }
    

    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view!).inset(UIEdgeInsets(top: 0, left: paddingSide, bottom: 0, right: paddingSide))
        }
    }
    
    @objc func loadLots() {
        NetworkManager.getLots({ lots in
            self.lots.removeAll()
            
            for lot in lots {
                self.lots.append(lot)
            }
            
            DispatchQueue.main.async(execute: {
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            })
        })
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

}

extension SelectLotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lotCellReuseIdentifier, for: indexPath) as! LotCollectionViewCell
        
        cell.configure(for: lots[indexPath.row], index: indexPath.row)
        
        return cell
    }
}

extension SelectLotViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 1 * padding) / 2
        let cellHeight = CGFloat(Int(cellWidth + 30))
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
}


extension SelectLotViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lot = lots[indexPath.row]
        coordinator?.displayParkingTypes(for: lot)
    }
}
