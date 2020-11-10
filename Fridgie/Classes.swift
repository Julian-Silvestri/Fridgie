//
//  Classes.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-03.
//

import Foundation


class CurrentInventory: Codable {
    let id: Int
    let item_name: String
    let quantity: Int
    let barcode_value, category: String

    init(id: Int, item_name: String, quantity: Int, barcode_value: String, category: String) {
        self.id = id
        self.item_name = item_name
        self.quantity = quantity
        self.barcode_value = barcode_value
        self.category = category
    }
}
