//
//  AddFridgeItemVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-16.
//

import UIKit

class AddFridgeItemVC: UIViewController {
    
    @IBOutlet weak var scannerBtn: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        
        self.barcodeValueField.layer.borderWidth = 1
        self.quantityField.layer.borderWidth = 1
        self.itemNameField.layer.borderWidth = 1
        self.scannerBtn.layer.cornerRadius = 5
        self.barcodeValueField.text = self.barcode
        self.addItemBtn.layer.cornerRadius = 8
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapOccured))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Status Bar Style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    
    //MARK: Tap Occured
    @objc func tapOccured(){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 60
            self.view.endEditing(true)
        }

    }
    
    //MARK: Keyboard Will Show
    @objc func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 60
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
    @IBAction func scannerBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "scanner", sender: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension AddFridgeItemVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//        self.mainStackView.frame.origin.y += 60
//    }
//}
