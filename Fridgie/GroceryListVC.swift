//
//  GroceryListVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-19.
//

import UIKit

class GroceryTableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
}



class GroceryListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var groceryTV: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.black
            self.tabBarController?.view.tintColor = UIColor.black
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.groceryTV.backgroundColor = UIColor.white
        }
    }
    
    //MARK: Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        for data in Globals.currentFridgeInventory {
            if data.category.lowercased() == "list" {
                count += 1
            }
        }
        
        return count
    }
    
    //MARK: Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.groceryTV.dequeueReusableCell(withIdentifier: "list") as! GroceryTableCell
       
        var data: CurrentInventory
        
        data = Globals.currentFridgeInventory[indexPath.row]
        
        if data.category.lowercased() == "list" {
            cell.name.text = data.category
        }
       
        return cell 
        
    }
    

}
