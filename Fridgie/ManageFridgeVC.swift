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

class ManageFridgeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var manageFridgeTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageFridgeTV.delegate = self
        self.manageFridgeTV.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = manageFridgeTV.dequeueReusableCell(withIdentifier: "manageCell") as! ManageFridgeCell
        
        cell.group.text = "World"
        cell.name.text = "Hello"
        
        return cell
    }
    
    
    
}
