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
    
    var fakeContents = ["Eggs","Bacon","Cheese","Milk","Bread","Olives","Chicken","Lettuce","Tomatoes","Cucumber","Zuchini","Peppers"]
    var groups = ["Protien","Protien","Dairy","Dairy","Grain","Fruit","Protien","Vegtable","Vegtable","Vegtable","Vegtable","Vegtable"]
    
    var currentContents = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.closedFridge.alpha = 1
        self.currentContents = fakeContents
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.currentContents.count <= 0 {
            
        } else {
            
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
        
        cell.group.text = groups[indexPath.row]
        cell.name.text = fakeContents[indexPath.row]
        
        return cell
    }
    
    func closeFridge(){
        UIView.animate(withDuration: 0.5, animations: {
            self.emptyFridgeOpen.alpha = 0
            self.fullFridgeOpen.alpha = 0
        }, completion: { _ in
            self.closedFridge.alpha = 1
        })
    }
    
    func openFridge(){
        if self.closedFridge.alpha == 1 {
            if self.currentContents.count >= 1 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.closedFridge.alpha = 0
                    self.emptyFridgeOpen.alpha = 0
                },completion: { _ in
                    self.fullFridgeOpen.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.closedFridge.alpha = 0
                    self.fullFridgeOpen.alpha = 0
                },completion: { _ in
                    self.emptyFridgeOpen.alpha = 1
                })
            }
        }
    }

}

