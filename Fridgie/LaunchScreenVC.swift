//
//  LaunchScreenVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-17.
//

import UIKit

class LaunchScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = UIColor.white
        }
    }
    

}
