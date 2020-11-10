//
//  MainVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-03.
//

import UIKit
import Foundation

class FridgeCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var group: UILabel!
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {


    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var fullFridgeOpen: UIImageView!
    @IBOutlet weak var emptyFridgeOpen: UIImageView!
    @IBOutlet weak var closedFridge: UIImageView!
    @IBOutlet weak var fridgeTV: UITableView!
    @IBOutlet weak var titleLabel: UILabel!

    let searchController = UISearchController(searchResultsController: nil)
    var resultsSearchController = UISearchController()
    var isFridgeOpen:Bool?
    var fakeContents = ["Eggs","Bacon","Cheese","Milk","Bread","Olives","Chicken","Lettuce","Tomatoes","Cucumber","Zuchini","Peppers"]
    var groups = ["Protien","Protien","Dairy","Dairy","Grain","Fruit","Protien","Vegtable","Vegtable","Vegtable","Vegtable","Vegtable"]
    
    var tapGesture = UITapGestureRecognizer()
    var refreshController = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.searchBar.delegate = self
        self.resultsSearchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchBarView.addSubview(searchController.searchBar)
        self.searchBarView.clipsToBounds = true
        self.searchController.searchBar.clipsToBounds = true
        
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.frame = CGRect(x:0,y:0, width: self.searchBarView.frame.size.width,height: self.searchController.searchBar.frame.size.height)
        self.searchBarView.bringSubviewToFront(searchController.searchBar)
        self.definesPresentationContext = true
        
        self.searchController.becomeFirstResponder()

        self.isFridgeOpen = false
        self.closedFridge.alpha = 1
        
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

        grabFridgeItems(completionHandler: { success, response in
            if success == true {
                print("good to go")
            } else {
                print("not good to go")
            }
        })
    }
    
    //MARK: ViewWill Appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.fridgeTV.alpha = 0
        self.emptyFridgeOpen.alpha = 0
        self.closedFridge.alpha = 1
        
//        print(currentContents)
    }

    //MARK: Tap Occured
    @objc func tapOccured(){
        print("TAP OCCURED")
        
        if self.isFridgeOpen == false {
            self.openFridge()
        } else {
            self.closeFridge()
        }

    }
    
    //MARK: Handle Top Refresh
    @objc func handleTopRefresh(sender: UIRefreshControl){
        //load data again 1. remove data, 2. add again
        sender.endRefreshing()

    }

    @IBAction func dontTouch(_ sender: Any) {
//        if self.currentContents.count >= 1 {
//            self.currentContents.removeAll()
//        }
//
//        postFridgeItem(itemName: "newFridge", quantity: 10, barcodeValue: "12412421", category: "vegFruit", completionHandler: {success, result in
//            if success == true {
//                print("something happened")
//            } else {
//                print("something bad has happened")
//            }
//        })
//        grabFridgeItems(completionHandler: { success, response in
//            if success == true {
//                print("good to go")
//            } else {
//                print("not good to go")
//            }
//        })
    }
    
    //MARK: Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {

            return Globals.filteredCurrentFridgeInventory.count
        } else {
            return Globals.currentFridgeInventory.count
        }
    }
    
    //MARK: Cell For ROw
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fridgeTV.dequeueReusableCell(withIdentifier: "fridgeCell") as! FridgeCell
        
        var dataToUse: CurrentInventory
        
        if isFiltering(){
            dataToUse = Globals.filteredCurrentFridgeInventory[indexPath.row]
        } else {
            dataToUse = Globals.currentFridgeInventory[indexPath.row]
        }

        cell.name.text = dataToUse.item_name

        return cell
    }
    
    //MARK: Close Fridge
    func closeFridge(){
        self.isFridgeOpen = false
        if Globals.currentFridgeInventory.count >= 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.fridgeTV.alpha = 0
            }, completion: { _ in
                self.closedFridge.alpha = 1
                return
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.emptyFridgeOpen.alpha = 0
            }, completion: { _ in
                self.closedFridge.alpha = 1
                return
            })
        }
        

    }
    
    //MARK: Open Fridge
    func openFridge(){
        self.fridgeTV.isHidden = false
        self.isFridgeOpen = true
        if self.closedFridge.alpha == 1 {
            if Globals.currentFridgeInventory.count >= 1 {
                print("here")
                self.fridgeTV.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.closedFridge.alpha = 1
                },completion: { _ in
                    self.fridgeTV.alpha = 1
                    return
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.emptyFridgeOpen.alpha = 1
                    self.fridgeTV.isHidden = true
                },completion: { _ in
                    return
                })
            }
        }
    }
    
    //MARK: IS Filtering
    func isFiltering() ->Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    //MARK: Search Bar is EMpty
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK: Update SearchResults
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print("\(text)")
        let updateArr = Globals.currentFridgeInventory.filter({
            
            return $0.item_name.lowercased().contains(text.lowercased())
        })

        Globals.filteredCurrentFridgeInventory = updateArr
        self.fridgeTV.reloadData()
    }

}

