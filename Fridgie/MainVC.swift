//
//  MainVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-03.
//

import UIKit

class FridgeCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var group: UILabel!
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fullFridgeOpen: UIImageView!
    @IBOutlet weak var emptyFridgeOpen: UIImageView!
    @IBOutlet weak var closedFridge: UIImageView!
    @IBOutlet weak var fridgeTV: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var fakeContents = ["Eggs","Bacon","Cheese","Milk","Bread","Olives","Chicken","Lettuce","Tomatoes","Cucumber","Zuchini","Peppers"]
    var groups = ["Protien","Protien","Dairy","Dairy","Grain","Fruit","Protien","Vegtable","Vegtable","Vegtable","Vegtable","Vegtable"]
    
    var tapGesture = UITapGestureRecognizer()
    var currentContents = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closedFridge.alpha = 1
        self.currentContents = fakeContents
        self.fridgeTV.delegate = self
        self.fridgeTV.dataSource = self
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.addTarget(self, action: #selector(tapOccured))
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.black
            self.tabBarController?.view.tintColor = UIColor.black
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.fridgeTV.backgroundColor = UIColor.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.fridgeTV.alpha = 0
//        self.fullFridgeOpen.alpha = 0
//        self.emptyFridgeOpen.alpha = 0
        self.closedFridge.alpha = 1
        
        print(currentContents)
    }
    
    @objc func tapOccured(){
        print("TAP OCCURED")
        if self.fridgeTV.alpha == 0 {
            print("opening Fridge")
            self.openFridge()
        } else {
            print("Closing Fridge")
            self.closeFridge()
        }
    }

    @IBAction func dontTouch(_ sender: Any) {
        if self.currentContents.count >= 1 {
            self.currentContents.removeAll()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fridgeTV.dequeueReusableCell(withIdentifier: "fridgeCell") as! FridgeCell
        
//        for data in currentContents[indexPath.row]{
//            cell.name.text = data
//        }
//        for data in groups[indexPath.row] {
//            cell.group.text = data
//        }
//
        cell.group.text = groups[indexPath.row]
        cell.name.text = currentContents[indexPath.row]

        return cell
    }
    
    func closeFridge(){
        UIView.animate(withDuration: 0.5, animations: {
            self.fridgeTV.alpha = 0
        }, completion: { _ in
//            self.emptyFridgeOpen.alpha = 0
//            self.fullFridgeOpen.alpha = 0
            self.closedFridge.alpha = 1
            return
        })
    }
    
    func openFridge(){
        if self.closedFridge.alpha == 1 {
            if self.currentContents.count >= 1 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.closedFridge.alpha = 1
//                    self.emptyFridgeOpen.alpha = 0
//                    self.fullFridgeOpen.alpha = 1
                },completion: { _ in
                    self.fridgeTV.alpha = 1
                    return
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.closedFridge.alpha = 0
//                    self.fullFridgeOpen.alpha = 0
                    self.emptyFridgeOpen.alpha = 1
                },completion: { _ in
                    self.fridgeTV.alpha = 1
                    return
                })
            }
        }
    }

}

