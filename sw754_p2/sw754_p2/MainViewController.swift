//
//  MainViewController.swift
//  sw754_p2
//
//  Created by Scott Wang on 10/6/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import UIKit

class UITextFieldChangable: UITextField {
    var empty = true;
}

struct GroceryItem {
    var name: String
    var amount: Int
}

class MainViewController: UIViewController {

    
    var groceryItems: [String: Int] = [:]
    var groceryList: [GroceryItem] = []
    
    var background: UIView!
    var spacer: UIView!
    
    var inputGroceryView: UIView!
    var greetingLabel: UILabel!
    var questionLabel: UILabel!
    
    var groceryInput: UITextFieldChangable!
    var numInput: UITextFieldChangable!
    
    var groceryItemToAdd = ""
    var numItemsToAdd = 1
    
    var submitBtn: UIButton!
    
    let itemCellId = "itemCellId"
    
    var labelHeightMultipler: CGFloat = 0.075
    
    var btnHeight: CGFloat = 50
    var btnWidth: CGFloat = 100

    var groceryItemEmpty = true
    var groceryNumberEmpty = true
    
    var groceryOutput: UILabel!
    
    var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background = UIView()
        background.backgroundColor = .white
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        
        
        spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spacer)
        
        inputGroceryView = UIView()
        inputGroceryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputGroceryView)
        
        greetingLabel = UILabel()
        greetingLabel.text = "Add Stuff"
        greetingLabel.textColor = .black
        greetingLabel.textAlignment = .center
        greetingLabel.font = .systemFont(ofSize: 45, weight: .thin)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(greetingLabel)
        
        
        groceryInput = UITextFieldChangable()
        groceryInput.borderStyle = .none
        groceryInput.font = .systemFont(ofSize: 25, weight: .thin)
        groceryInput.translatesAutoresizingMaskIntoConstraints = false
        groceryInput.addTarget(self, action: #selector(groceryTextDidChange(_:)), for: UIControl.Event.editingChanged)
        groceryInput.placeholder = "Click to add groceries..."
        
        view.addSubview(groceryInput)
        
        numInput = UITextFieldChangable()
        numInput.borderStyle = .none
        numInput.font = .systemFont(ofSize: 25, weight: .thin)
        numInput.translatesAutoresizingMaskIntoConstraints = false
        numInput.addTarget(self, action: #selector(numTextDidChange(_:)), for: UIControl.Event.editingChanged)
        numInput.placeholder = "Enter a valid amount..."
        numInput.isHidden = true;
        
        view.addSubview(numInput)
        
        submitBtn = UIButton()
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.backgroundColor = .white
        submitBtn.addTarget(self, action: #selector(submitBtnPressed), for: .touchUpInside)
        
        submitBtn.setTitle("Add", for: .normal)
        submitBtn.setTitleColor(.systemBlue, for: .normal)
//        submitBtn.layer.borderColor = UIColor.systemBlue.cgColor
//        submitBtn.layer.borderWidth = 1
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitBtn)
        submitBtn.isHidden = true

        
        groceryOutput = UILabel()
//        groceryOutput.font = .systemFont(ofSize: 15, weight: .thin)
//        groceryOutput.numberOfLines = 0
//        groceryOutput.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(groceryOutput)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.register(ItemViewCell.self, forCellReuseIdentifier: itemCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        
        setupConstraints()
        
        addItem("Sausages", 5)
        addItem("Carrots", 5)
        addItem("Beets", 2)
        
    }
    
    func addItem(_ item: String, _ amount: Int?) {
        guard let numItems = amount else {
            return
        }
        
        if groceryItems[item] != nil {
            groceryItems[item]! += numItems
        } else {
            groceryItems[item] = amount
        }
        
    }
    
    @objc func groceryTextDidChange(_ textField: UITextFieldChangable) {
        if let val = textField.text {
            if (val.count > 0) {
                textField.empty = false
                numInput.isHidden = false
                groceryItemToAdd = val
                return
            }
        }
        textField.empty = true
        numInput.text = ""
        numInput.isHidden = true
        submitBtn.isHidden = true
    }
    
    @objc func numTextDidChange(_ textField: UITextFieldChangable) {
        if let val = textField.text {
            if (val.count > 0) {
                if let num = Int(val) {
                    if (num > 0) {
                        textField.empty = false
                        submitBtn.isHidden = false
                        numItemsToAdd = num
                        return
                    }
                    
                }
            }
        }
        
        textField.empty = true
        submitBtn.isHidden = true
    }
    
    @objc func submitBtnPressed() {
        addItem(groceryItemToAdd, numItemsToAdd)
        
        generateGroceryList()
        print(groceryList)
    }
    
    func generateGroceryList()  {
        groceryList = []
        for (k, v) in groceryItems {
            groceryList.append(GroceryItem(name: k, amount: v))
        }
        
        var msg = ""
        for item in groceryList {
            msg = msg + "\(item.name): \(item.amount)\n"
        }
        
        groceryOutput.text = msg
        tableView.reloadData()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: view.topAnchor),
            spacer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            spacer.widthAnchor.constraint(equalTo: view.widthAnchor),
            spacer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            greetingLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: labelHeightMultipler)
        ])
        
        NSLayoutConstraint.activate([
            groceryInput.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor),
            groceryInput.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: labelHeightMultipler),
            groceryInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groceryInput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            numInput.topAnchor.constraint(equalTo: groceryInput.bottomAnchor),
            numInput.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: labelHeightMultipler),
            numInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numInput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            submitBtn.topAnchor.constraint(equalTo: numInput.bottomAnchor),
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitBtn.heightAnchor.constraint(equalToConstant: btnHeight),
            submitBtn.widthAnchor.constraint(equalToConstant: btnWidth)
        ])
        
//        NSLayoutConstraint.activate([
//            groceryOutput.topAnchor.constraint(equalTo: submitBtn.bottomAnchor),
//            groceryOutput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
//            groceryOutput.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            groceryOutput.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: submitBtn.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let val = groceryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId) as! ItemViewCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.clear
        cell.update(val)
        
        return cell
    }
    
    
}
