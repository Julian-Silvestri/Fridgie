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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {


    @IBOutlet weak var searchBarCustom: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var fullFridgeOpen: UIImageView!
    @IBOutlet weak var emptyFridgeOpen: UIImageView!
    @IBOutlet weak var closedFridge: UIImageView!
    @IBOutlet weak var fridgeTV: UITableView!
    @IBOutlet weak var titleLabel: UILabel!

    var isFridgeOpen:Bool?
    var tapGesture = UITapGestureRecognizer()
    var refreshController = UIRefreshControl()
    var searchActive: Bool?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.fridgeTV.delegate = self
        self.fridgeTV.dataSource = self
        self.definesPresentationContext = true
        self.searchBarCustom.delegate = self
        
        self.searchBarCustom.barTintColor = UIColor.white
        self.searchBarCustom.searchTextField.tintColor = UIColor.black
        self.searchBarCustom.backgroundColor = UIColor.white
        self.searchBarCustom.searchTextField.textColor = UIColor.black
        self.searchBarCustom.searchTextField.tintColor = UIColor.black
        self.searchBarCustom.searchTextField.setLeftIcon(UIImage(named: "searchIcon")!)
        self.isFridgeOpen = false
        self.closedFridge.alpha = 1

        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.addTarget(self, action: #selector(tapOccured))
        self.refreshController.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        self.refreshController.addTarget(self, action: #selector(handleTopRefresh), for: .valueChanged)
        self.fridgeTV.addSubview(self.refreshController)
        establishUIStyle(tbController: self.tabBarController, labels: [self.titleLabel], buttons: nil, textFields: nil, segmentControl: nil)
        
        grabFridgeItems(completionHandler: { success, response in
            if success == true {
                print("good to go")
                DispatchQueue.main.async {
                    self.fridgeTV.reloadData()
                }
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
        self.fridgeTV.reloadData()

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
    
    //MARK: Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: Handle Top Refresh
    @objc func handleTopRefresh(sender: UIRefreshControl){
        Globals.currentFridgeInventory.removeAll()
        Globals.filteredCurrentFridgeInventory.removeAll()
        grabFridgeItems(completionHandler: {result, response in
            if result == true {
                DispatchQueue.main.async {
                    self.fridgeTV.reloadData()
                }
            }
        })
        sender.endRefreshing()

    }

    
    //MARK: Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive == true {
            return Globals.filteredCurrentFridgeInventory.count
        } else {
            return Globals.currentFridgeInventory.count
        }
    }
    
    //MARK: Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fridgeTV.dequeueReusableCell(withIdentifier: "fridgeCell") as! FridgeCell
        
        cell.name.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        cell.backgroundView?.backgroundColor = UIColor.white
        
        self.fridgeTV.backgroundColor = UIColor.white
        self.fridgeTV.tintColor = UIColor.white
        self.searchBarView.backgroundColor = UIColor.white
        self.searchBarCustom.backgroundColor = UIColor.white
        
        var dataToUse: CurrentInventory

        if self.searchActive == true {
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
        
        self.searchBarCustom.endEditing(true)
        self.fridgeTV.reloadData()
        

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
                    UIView.animate(withDuration: 0.5, animations: {
                        self.fridgeTV.alpha = 1
                    })
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
        self.searchBarCustom.endEditing(true)
        self.fridgeTV.reloadData()
    }
    
    //MARK: IS Filtering
    func isFiltering() ->Bool {
        return self.searchBarCustom.searchTextField.text?.isEmpty ?? false && !searchBarIsEmpty()
    }
    
    //MARK: Search Bar is EMpty
    func searchBarIsEmpty() -> Bool {
        return self.searchBarCustom.text?.isEmpty ?? true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.fridgeTV.reloadData()
    }
    
    //MARK: Search Bar - Filtering
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let updateArr = Globals.currentFridgeInventory.filter({
            return $0.item_name.lowercased().range(of: searchText.lowercased()) != nil
        })
        if(searchText == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        Globals.filteredCurrentFridgeInventory = updateArr
        self.fridgeTV.reloadData()

    }
    
}

