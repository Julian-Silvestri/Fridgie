//
//  ManageFridgeVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-03.
//

import UIKit

class ManageFridgeCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var group: UILabel!
    
}

class ManageFridgeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {


    @IBOutlet weak var manageSearchBar: UISearchBar!
    @IBOutlet weak var manageFridgeTV: UITableView!
    
    var searchActive: Bool?
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageFridgeTV.delegate = self
        self.manageFridgeTV.dataSource = self
        self.manageSearchBar.delegate = self
        self.definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchActive == true{
            return Globals.filteredCurrentFridgeInventory.count
        } else {
            return Globals.currentFridgeInventory.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = manageFridgeTV.dequeueReusableCell(withIdentifier: "manageCell") as! ManageFridgeCell
        
        let data: CurrentInventory
        
        if self.searchActive == true{
            data = Globals.filteredCurrentFridgeInventory[indexPath.row]
        } else {
            data = Globals.currentFridgeInventory[indexPath.row]
        }
        
        cell.group.text = data.category
        cell.name.text = data.item_name
        
        return cell
    }
    
    
    //MARK: IS Filtering
    func isFiltering() ->Bool {
        return self.manageSearchBar.searchTextField.text?.isEmpty ?? false && !searchBarIsEmpty()
    }
    
    //MARK: Search Bar is EMpty
    func searchBarIsEmpty() -> Bool {
        return self.manageSearchBar.text?.isEmpty ?? true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.manageFridgeTV.reloadData()
    }
    
    //MARK: Search Bar - Filtering
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let updateArr = Globals.currentFridgeInventory.filter({
            return $0.item_name.lowercased().range(of: searchText.lowercased()) != nil || $0.category.lowercased().range(of: searchText.lowercased()) != nil
        })
        if(searchText == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        Globals.filteredCurrentFridgeInventory = updateArr
        self.manageFridgeTV.reloadData()

    }
    
    
    //MARK: Handle Top Refresh
    @objc func handleTopRefresh(sender: UIRefreshControl){
        Globals.currentFridgeInventory.removeAll()
        Globals.filteredCurrentFridgeInventory.removeAll()
        grabFridgeItems(completionHandler: {result, response in
            if result == true {
                DispatchQueue.main.async {
                    self.manageFridgeTV.reloadData()
                }
            }
        })
        sender.endRefreshing()

    }
    
    
}
