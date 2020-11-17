//
//  AddFridgeItemVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-16.
//

import UIKit

class AddFridgeItemVC: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var foodGroupSegment: UISegmentedControl!
    @IBOutlet weak var barcodeValueField: UITextField!
    @IBOutlet weak var addItemBtn: UIButton!
    
    var name: String?
    var quantity: Int?
    var foodGroup: String?
    var barcode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemNameField.text = self.name
        self.quantityField.text = "\(self.foodGroup ?? "")"
        
        if self.foodGroup == "grains" {
            self.foodGroupSegment.selectedSegmentIndex = 1
        } else if self.foodGroup == "meats" {
            self.foodGroupSegment.selectedSegmentIndex = 0
        } else if self.foodGroup == "vegFruit" {
            self.foodGroupSegment.selectedSegmentIndex = 3
        } else if self.foodGroup == "dairy" {
            self.foodGroupSegment.selectedSegmentIndex = 2
        }
        
        self.barcodeValueField.text = self.barcode
        
        self.addItemBtn.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Close Btn Action
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Add Item action
    @IBAction func addItemAction(_ sender: Any) {
        CustomLoader.instance.showLoaderView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            CustomLoader.instance.hideLoaderView()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
}
