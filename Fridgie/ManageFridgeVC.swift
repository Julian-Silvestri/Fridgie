//
//  ManageFridgeVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-03.
//

import UIKit

class ManageFridgeCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var foodGroupLabel: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
}

class ManageFridgeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var manageSearchBar: UISearchBar!
    @IBOutlet weak var manageFridgeTV: UITableView!
    @IBOutlet weak var addFridgeItemBtn: UIButton!
    
    var searchActive: Bool?
    var refreshController = UIRefreshControl()
    var tapGesture = UITapGestureRecognizer()
    var itemName = ""
    var barcodeValue = ""
    var category = ""
    var id = ""
    var quantity = ""
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapGesture.delegate = self
        self.manageFridgeTV.delegate = self
        self.manageFridgeTV.dataSource = self
        self.manageSearchBar.delegate = self
        self.definesPresentationContext = true
        self.manageFridgeTV.addSubview(self.refreshController)
        self.addFridgeItemBtn.layer.cornerRadius = 10
        self.manageSearchBar.searchTextField.setLeftIcon(UIImage(named: "searchIcon")!)
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.black
            self.tabBarController?.view.tintColor = UIColor.black
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.manageFridgeTV.backgroundColor = UIColor.white
            self.manageFridgeTV.backgroundView?.backgroundColor = UIColor.white
            
        }
        self.manageSearchBar.barTintColor = UIColor.white
        self.manageSearchBar.searchTextField.tintColor = UIColor.black
        self.manageSearchBar.backgroundColor = UIColor.white
        self.manageSearchBar.searchTextField.textColor = UIColor.black
        self.manageSearchBar.searchTextField.tintColor = UIColor.black
        self.tapGesture.addTarget(self, action: #selector(tapOccured))
        self.view.addGestureRecognizer(self.tapGesture)
        self.tapGesture.cancelsTouchesInView = false
        self.manageFridgeTV.canCancelContentTouches = false
        //self.manageFridgeTV.canCancelContentTouches = true
    }
    
    //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    
    //MARK: Height For Row At
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    //MARK: Number of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive == true{
            return Globals.filteredCurrentFridgeInventory.count
        } else {
            return Globals.currentFridgeInventory.count
        }
    }
    
    //MARK: Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = manageFridgeTV.dequeueReusableCell(withIdentifier: "manageCell") as! ManageFridgeCell
        

        cell.backgroundColor = UIColor.white
        cell.group.textColor = UIColor.black
        cell.name.textColor = UIColor.black
        cell.quantity.textColor = UIColor.black
        cell.nameLabel.textColor = UIColor.black
        cell.foodGroupLabel.textColor = UIColor.black
        cell.quantityLabel.textColor = UIColor.black
        cell.deleteBtn.layer.cornerRadius = 5
        
        let data: CurrentInventory
        
        if self.searchActive == true{
            data = Globals.filteredCurrentFridgeInventory[indexPath.row]
        } else {
            data = Globals.currentFridgeInventory[indexPath.row]
        }
        
        cell.group.text = data.category
        cell.name.text = data.item_name
        
        cell.deleteBtn.tag = data.id
        
        return cell
    }
    
    //MARK: Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("&&&&&&&&& \(indexPath)")
        
        
        let data: CurrentInventory
        
        if self.searchActive == true {
            data = Globals.filteredCurrentFridgeInventory[indexPath.row]
            self.id = "\(data.id)"
            self.category = data.category
            self.barcodeValue = data.barcode_value
            self.itemName = data.item_name
            self.quantity = "\(data.quantity)"

        } else {
            data = Globals.filteredCurrentFridgeInventory[indexPath.row]
            self.id = "\(data.id)"
            self.category = data.category
            self.barcodeValue = data.barcode_value
            self.itemName = data.item_name
            self.quantity = "\(data.quantity)"
            
        }
        
        self.performSegue(withIdentifier: "editItem", sender: self)

    }
    
    
    //MARK: IS Filtering
    func isFiltering() ->Bool {
        return self.manageSearchBar.searchTextField.text?.isEmpty ?? false && !searchBarIsEmpty()
    }
    
    //MARK: Search Bar is EMpty
    func searchBarIsEmpty() -> Bool {
        return self.manageSearchBar.text?.isEmpty ?? true
    }
    
    //MARK: Search Bar cancel button clicked
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
    
    //MARK: Delete Action
    @IBAction func deleteBtn(_ sender: UIButton) {
        
        CustomLoader.instance.showLoaderView()
        
        if searchActive == true {
            DispatchQueue.main.async {
                Globals.filteredCurrentFridgeInventory.removeAll(where: {$0.id == sender.tag})
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.manageFridgeTV.reloadData()
                    CustomLoader.instance.hideLoaderView()
                })
            }
        } else {
            DispatchQueue.main.async {
                Globals.currentFridgeInventory.removeAll(where: {$0.id == sender.tag})
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.manageFridgeTV.reloadData()
                    CustomLoader.instance.hideLoaderView()
                })
            }
        }
    }
    
    //MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItem" {
            let destinationVC = segue.destination as? EditFridgeItemVC
            destinationVC?.barcode = self.barcodeValue
            destinationVC?.category = self.category
            destinationVC?.name = self.itemName
            destinationVC?.id = self.id
        }
        if segue.identifier == "addItem" {
            let destinationVC = segue.destination as? AddFridgeItemVC
//            destinationVC?.barcode = self.barcodeValue
//            destinationVC?.category = self.category
//            destinationVC?.quantity = self.quantity
//            destinationVC?.name = self.itemName
//            destinationVC?.id = self.id
            
        }
        
    }
    

    //MARK: Edit Btn Action
//    @IBAction func editBtnAction(_ sender: Any) {
//
//        self.performSegue(withIdentifier: "editItem", sender: self)
//    }
    
    
    
    //MARK: Tap Occured
    @objc func tapOccured(){
        print("TAP OCCURED")
        let locationOfTap = tapGesture.location(in: self.manageFridgeTV)

        if tapGesture.view?.isDescendant(of: self.manageFridgeTV) == true {
            print("tapped inside table view")
            
        }
        
        
//        
//        if tapGesture.location(in: self.manageFridgeTV) >= CGPoint(0.0) {
//            print("tapped inside table view")
//        } else {
//            print("no tap inside table view")
//            
//        }
    
        print("*&*&")
        print(locationOfTap)
        self.view.endEditing(true)
    }
    
    @IBAction func addFridgeItemAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addItem", sender: self)
    }
    
    
}
extension UITextField {

    func setLeftIcon(_ icon: UIImage) {
        
        let padding = 8
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor.black
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
}
