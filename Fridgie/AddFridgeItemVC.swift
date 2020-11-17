//
//  AddFridgeItemVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-16.
//

import UIKit

class AddFridgeItemVC: UIViewController {
    
    @IBOutlet weak var barcodeValueLabel: UILabel!
    @IBOutlet weak var foodGroupLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var foodGroupSegment: UISegmentedControl!
    @IBOutlet weak var barcodeValueField: UITextField!
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var name: String?
    var quantity: Int?
    var foodGroup: String?
    var barcode: String?
    var tapGesture = UITapGestureRecognizer()
    var quantityIsTapped: Bool?
    var barcodeIsTapped: Bool?

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
        
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.black
            self.tabBarController?.view.tintColor = UIColor.black
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.itemNameField.backgroundColor = UIColor.white
            self.itemNameLabel.textColor = UIColor.black
            self.quantityLabel.textColor = UIColor.black
            self.foodGroupLabel.textColor = UIColor.black
            self.barcodeValueLabel.textColor = UIColor.black
            self.itemNameField.tintColor = UIColor.black
            self.quantityField.backgroundColor = UIColor.white
            self.barcodeValueField.backgroundColor = UIColor.white
            self.quantityField.layer.borderColor = UIColor.black.cgColor
            self.foodGroupSegment.tintColor = UIColor.black
            self.foodGroupSegment.selectedSegmentTintColor = UIColor.black
            self.barcodeValueField.layer.borderColor = UIColor.black.cgColor
            self.barcodeValueField.textColor = UIColor.black
            self.itemNameField.layer.borderColor = UIColor.black.cgColor
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name:UIResponder.keyboardWillShowNotification, object: nil);
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name:UIResponder.keyboardWillHideNotification, object: nil);
        
        self.barcodeValueField.layer.borderWidth = 1
        self.quantityField.layer.borderWidth = 1
        self.itemNameField.layer.borderWidth = 1
        self.barcodeValueField.text = self.barcode
        self.addItemBtn.layer.cornerRadius = 8
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOccured))
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        if self.quantityField.isEditing == true {
            self.quantityLabel.frame.origin.y -= 10
            self.quantityField.frame.origin.y -= 10
        } else if self.barcodeValueField.isEditing == true {
//            self.foodGroupSegment.frame.origin.y -= 50
//            self.foodGroupLabel.frame.origin.y -= 50
//            self.quantityLabel.frame.origin.y -= 30
//            self.quantityField.frame.origin.y -= 30
            self.barcodeValueField.frame.origin.y -= 150
            self.barcodeValueLabel.frame.origin.y -= 150
        }
    
    }

//    @objc func keyboardWillHide(sender: NSNotification) {
//        if self.quantityField.isEditing == false {
//            self.quantityField.frame.origin.y += 10
//            self.quantityField.frame.origin.y += 10
//        } else if self.barcodeValueField.isEditing == false {
//            self.barcodeValueField.frame.origin.y += 50
//            self.barcodeValueLabel.frame.origin.y += 50
//        }
//    }
    
    //MARK: Tap Occured
    @objc func tapOccured(){
        print("TAP OCCURED")

        self.view.endEditing(true)
        
//        if self.quantityField.frame.origin.y == 238 {
//            self.quantityField.frame.origin.y += 10
//            self.quantityLabel.frame.origin.y += 10
//        } else if self.barcodeValueField.frame.origin.y == 319 {
//            self.foodGroupSegment.frame.origin.y += 50
//            self.foodGroupLabel.frame.origin.y += 50
//            self.quantityLabel.frame.origin.y += 30
//            self.quantityField.frame.origin.y += 30
//            self.barcodeValueField.frame.origin.y += 150
//            self.barcodeValueLabel.frame.origin.y += 150
//        }
    }
    
    func quantityTapped() {
        self.quantityIsTapped = true
        if self.quantityLabel.frame.origin.y != 238 {
            self.quantityLabel.frame.origin.y -= 10
            self.quantityField.frame.origin.y -= 10
        } else {
            return
        }

    }
    
    func untapQuantity() {
        self.quantityIsTapped = false
        if self.quantityLabel.frame.origin.y != 238 {
            self.quantityLabel.frame.origin.y += 10
            self.quantityField.frame.origin.y += 10
        } else {
            return
        }

    }
    
    func barcodeTapped() {
        self.barcodeIsTapped = true
        if self.barcodeValueLabel.frame.origin.y != 319 {
            self.barcodeValueField.frame.origin.y -= 150
            self.barcodeValueLabel.frame.origin.y -= 150
            self.foodGroupSegment.frame.origin.y -= 10
            self.foodGroupLabel.frame.origin.y -= 10
            self.quantityLabel.frame.origin.y -= 10
            self.quantityField.frame.origin.y -= 10
        }
    }
    
    func untapBarcode() {
        self.barcodeIsTapped = true
        if self.barcodeValueLabel.frame.origin.y != 319 {
            self.barcodeValueField.frame.origin.y -= 150
            self.barcodeValueLabel.frame.origin.y -= 150
            self.foodGroupSegment.frame.origin.y -= 10
            self.foodGroupLabel.frame.origin.y -= 10
            self.quantityLabel.frame.origin.y -= 10
            self.quantityField.frame.origin.y -= 10
        }
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
