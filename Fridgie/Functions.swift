//
//  Functions.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-09.
//

import Foundation

//MARK: Post Item In Fridge
func postFridgeItem(itemName: String, quantity: Int, barcodeValue: String, category: String, completionHandler: @escaping(Bool?, String?) -> Void) {
    guard let url = URL(string: "http://192.168.0.24/post_fridge_item.php") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let parameters = [
        "item_name": itemName,
        "quantity": quantity,
        "barcode_value": barcodeValue,
        "category": category
        
    ] as [String : Any]
    
    let postData = try? JSONSerialization.data(withJSONObject: parameters)
    request.httpBody = postData

    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print(error as? String ?? "")
            return
        }
        guard let data = data else {
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("*** HTTP STATUS CODE: \(httpResponse.statusCode)")
            
            if (httpResponse.statusCode == 503) { //service unavailable
                completionHandler(false, "STATUS 503: Cannot connect to API...")
                return
            } else if (httpResponse.statusCode == 401) { //unauthorized
                completionHandler(false, "STATUS 401: Unauthorized...")
                return
            } else if (httpResponse.statusCode != 200) {
                completionHandler(false, nil)
                return
            }
        } else {
            completionHandler(false, nil)
            return
        }

        do {
            print("Was it a success?")
        }
    }
    task.resume()
    return
}

//MARK: Remove Item From Fridge
func removeItemFromFridge(id: Int, completionHandler: @escaping(Bool?, String?) -> Void) {
    guard let url = URL(string: "http://192.168.0.24/remove_item_from_fridge.php") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let parameters = [
        "id": id,
    ] as [String : Any]
    
    let postData = try? JSONSerialization.data(withJSONObject: parameters)
    request.httpBody = postData

    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print(error as? String ?? "")
            return
        }
        guard let data = data else {
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("*** HTTP STATUS CODE: \(httpResponse.statusCode)")
            
            if (httpResponse.statusCode == 503) { //service unavailable
                completionHandler(false, "STATUS 503: Cannot connect to API...")
                return
            } else if (httpResponse.statusCode == 401) { //unauthorized
                completionHandler(false, "STATUS 401: Unauthorized...")
                return
            } else if (httpResponse.statusCode != 200) {
                completionHandler(false, nil)
                return
            }
        } else {
            completionHandler(false, nil)
            return
        }

        do {
            print("Removed item ?")
        }
    }
    task.resume()
    return
}


//MARK: Update Fridge Item
func updateFridgeItem(id: Int, itemName: String, quantity: String, barcodeValue: String, category: String, completionHandler: @escaping(Bool?, String?) -> Void) {
    guard let url = URL(string: "http://192.168.0.24/update_item_in_fridge.php") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let parameters = [
        "item_name": itemName,
    ] as [String : Any]
    
    let postData = try? JSONSerialization.data(withJSONObject: parameters)
    request.httpBody = postData

    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print(error as? String ?? "")
            return
        }
        guard let data = data else {
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("*** HTTP STATUS CODE: \(httpResponse.statusCode)")
            
            if (httpResponse.statusCode == 503) { //service unavailable
                completionHandler(false, "STATUS 503: Cannot connect to API...")
                return
            } else if (httpResponse.statusCode == 401) { //unauthorized
                completionHandler(false, "STATUS 401: Unauthorized...")
                return
            } else if (httpResponse.statusCode != 200) {
                completionHandler(false, nil)
                return
            }
        } else {
            completionHandler(false, nil)
            return
        }

        do {
            print("Was it a success?")
        }
    }
    task.resume()
    return
}


//MARK: Grab Inventory

func grabFridgeItems(completionHandler: @escaping(Bool?, String?) -> Void){
    guard let url = URL(string: "http://192.168.0.24/grab_all_fridge_items.php") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print(error as? String ?? "")
            return
        }
        guard let data = data else {
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("*** HTTP STATUS CODE: \(httpResponse.statusCode)")
            
            if (httpResponse.statusCode == 503) { //service unavailable
                completionHandler(false, "STATUS 503: Cannot connect to API...")
                return
            } else if (httpResponse.statusCode == 401) { //unauthorized
                completionHandler(false, "STATUS 401: Unauthorized...")
                return
            } else if (httpResponse.statusCode != 200) {
                completionHandler(false, nil)
                return
            }
        } else {
            completionHandler(false, nil)
            return
        }

        do {

            let json = try! JSONDecoder().decode([CurrentInventory].self, from: data)

            for items in json {
                Globals.currentFridgeInventory.append(CurrentInventory(id: items.id, item_name: items.item_name, quantity: items.quantity, barcode_value: items.barcode_value, category: items.category))
            }
            
            for items in json {
                Globals.filteredCurrentFridgeInventory.append(CurrentInventory(id: items.id, item_name: items.item_name, quantity: items.quantity, barcode_value: items.barcode_value, category: items.category))
            }

            dump(Globals.currentFridgeInventory)
            completionHandler(true, "success")

        }
    }
    task.resume()
    return
}
