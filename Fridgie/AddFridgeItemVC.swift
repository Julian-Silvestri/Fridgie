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
    var category: String?
    var barcode: String?
    var quantityIsTapped: Bool?
    var barcodeIsTapped: Bool?
    var id: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemNameField.text = self.name
        self.quantityField.text = "\(self.quantity ?? 0)"
        self.barcodeValueField.text = self.barcode
        
        if self.category == "grains" {
            self.foodGroupSegment.selectedSegmentIndex = 1
        } else if self.category == "meats" {
            self.foodGroupSegment.selectedSegmentIndex = 0
        } else if self.category == "vegFruit" {
            self.foodGroupSegment.selectedSegmentIndex = 3
        } else if self.category == "dairy" {
            self.foodGroupSegment.selectedSegmentIndex = 2
        }
        
        establishUIStyle(tbController: self.tabBarController, labels: [self.titleLabel,self.itemNameLabel, self.quantityLabel,self.foodGroupLabel,self.barcodeValueLabel], buttons: [self.scannerBtn, self.closeBtn, self.addItemBtn], textFields: [self.itemNameField, self.quantityField, self.barcodeValueField], segmentControl: [self.foodGroupSegment])

        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapOccured))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.view.addGestureRecognizer(tapGesture)
        
    }
    //MARK: View Will Appear
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
