//
//  Classes.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-03.
//

import Foundation


class CurrentInventory: Codable {
    let name: String
    let group: String
    let id: Int
    
    init(name: String, group: String, id: Int){
        self.name = name
        self.group = group
        self.id = id
        
    }
    
}
