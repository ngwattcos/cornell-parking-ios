//
//  SelectLotViewController.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class SelectLotViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var background: UIView!
    var padding: CGFloat = 10
    var paddingSide: CGFloat = 10
    let headerHeight: CGFloat = 30
    
    
    
    let lotCellReuseIdentifier = "lotCellReuseIdentifier"
    let headerReuseIdentifier = "headerReuseIdentifier"
    
    var lots: [Lot]! = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        
//        background = UIView()
//        background.backgroundColor = .white
//        background.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(background)
        
//        title = "Select Parking Lot"
        // Do any additional setup after loading the view.
        
        setupConstraints()
        loadLots()
    }
    

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: paddingSide),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -paddingSide),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func loadLots() {
        NetworkManager.getLots({ lots in
            self.lots.removeAll()
            
            for lot in lots {
                self.lots.append(lot)
            }
        })
        
        collectionView.reloadData()
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
        let cellSize = (collectionView.frame.width - 1 * padding) / 2
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
}


extension SelectLotViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let person = persons[indexPath.row]
//
//        if (person.name == "Bill Gates") {
//            persons[indexPath.row] = melinda
//        } else {
//            persons[indexPath.row] = bill
//        }
//
//        collectionView.reloadData()
    }
}
