//
//  EditFridgeItemVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2021-01-05.
//

import UIKit

class EditFridgeItemVC: UIViewController {
    
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var barcodeLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var itemNameLabel: UITextField!
    
    var name = ""
    var quantity = ""
    var barcode = ""
    var category = ""
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barcodeLabel.text = self.barcode
        self.quantityLabel.text = self.quantity
        self.itemNameLabel.text = self.name
        
        if category == "Meats" {
            self.categorySegment.selectedSegmentIndex = 0
        } else if category == "Grains" {
            self.categorySegment.selectedSegmentIndex = 1
        } else if category == "Dairy" {
            self.categorySegment.selectedSegmentIndex = 2
        } else if category == "VegFruit"{
            self.categorySegment.selectedSegmentIndex = 3
        }
        

        // Do any additional setup after loading the view.
    }

}
