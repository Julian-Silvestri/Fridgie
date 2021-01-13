//
//  EditFridgeItemVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2021-01-05.
//

import UIKit

class EditFridgeItemVC: UIViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var scannerBtn: UIButton!
    @IBOutlet weak var foodGroupLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var editItemTitle: UILabel!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var barcodeField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var itemNameField: UITextField!
    
    
    var name = ""
    var quantity = ""
    var barcode = ""
    var category = ""
    var id = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.barcodeField.text = self.barcode
        self.quantityField.text = self.quantity
        self.itemNameField.text = self.name
        
        if category == "Meats" {
            self.categorySegment.selectedSegmentIndex = 0
        } else if category == "Grains" {
            self.categorySegment.selectedSegmentIndex = 1
        } else if category == "Dairy" {
            self.categorySegment.selectedSegmentIndex = 2
        } else if category == "VegFruit"{
            self.categorySegment.selectedSegmentIndex = 3
        }
        
        //establishUIStyle(tbController: self.tabBarController, labels: [self.editItemTitle,self.barcodeLabel,self.quantityLabel,self.barcodeLabel, self.itemNameLabel, self.foodGroupLabel], buttons: [self.closeBtn, self.scannerBtn, self.saveBtn], textFields: [self.barcodeField, self.quantityField, self.itemNameField], segmentControl: [self.categorySegment])
        
        self.closeBtn.layer.cornerRadius = 5
        self.scannerBtn.layer.cornerRadius = 5
        self.saveBtn.layer.cornerRadius = 5
        self.barcodeField.layer.borderWidth = 1
        self.quantityField.layer.borderWidth = 1
        self.itemNameField.layer.borderWidth = 1
        
        if traitCollection.userInterfaceStyle == .dark {
            self.tabBarController?.view.tintColor = UIColor.black
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.editItemTitle.textColor = UIColor.black
            self.barcodeLabel.textColor = UIColor.black
            self.quantityLabel.textColor = UIColor.black
            self.itemNameLabel.textColor = UIColor.black
            self.foodGroupLabel.textColor = UIColor.black
            self.barcodeField.textColor = UIColor.black
            self.barcodeField.layer.borderColor = UIColor.black.cgColor
            self.quantityField.layer.borderColor = UIColor.black.cgColor
            self.quantityField.textColor = UIColor.black
            self.itemNameField.textColor = UIColor.black
            self.itemNameField.layer.borderColor = UIColor.black.cgColor
            
            self.view.backgroundColor = UIColor.white
        }

    }
    

    
    //MARK: Close Action
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Scanner Action
    @IBAction func scannerAction(_ sender: Any) {
        self.performSegue(withIdentifier: "scanner", sender: self)
    }
    //MARK: Save Action
    @IBAction func saveEditAction(_ sender: Any) {
    }
    
    //MARK: Setup view did load
    func setupViewDidLoad(){

    }
    
    

}
