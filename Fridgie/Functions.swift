//
//  Functions.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-09.
//

import Foundation
import UIKit



func alert(viewController: UIViewController, title: String, message: String, style:UIAlertController.Style, numberOfActions: Int, actionTitles:[String], actionStyles:[UIAlertAction.Style],actions:[((UIAlertAction) -> Void)?]) {
    
    let alert = UIAlertController(title: "\n\(title)", message: "\(message)\n\n", preferredStyle: style)
    
    for (index, title) in actionTitles.enumerated() {
        let style = actionStyles[index]
        let action = UIAlertAction(title: title, style: style, handler: actions[index])
        alert.addAction(action)
    }
    viewController.present(alert, animated: true, completion: nil)


}

//MARK: Post Item In Fridge
func postFridgeItem(itemName: String, quantity: Int, barcodeValue: String, category: String, completionHandler: @escaping(Bool?, String?) -> Void){
    var semaphore = DispatchSemaphore (value: 0)

    let parameters = [
      [
        "key": "item_name",
        "value": itemName,
        "type": "text"
      ],
      [
        "key": "quantity",
        "value": quantity,
        "type": "text"
      ],
      [
        "key": "barcode_value",
        "value": barcodeValue,
        "type": "text"
      ],
      [
        "key": "category",
        "value": category,
        "type": "text"
      ]] as [[String : Any]]

    let boundary = "Boundary-\(UUID().uuidString)"
    var body = ""
    var error: Error? = nil
    for param in parameters {
      if param["disabled"] == nil {
        let paramName = param["key"]!
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(paramName)\""
        let paramType = param["type"] as! String
        if paramType == "text" {
          let paramValue = param["value"] as! String
          body += "\r\n\r\n\(paramValue)\r\n"
        } else {
            do{
                let paramSrc = param["src"] as! String
                let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                let fileContent = String(data: fileData, encoding: .utf8)!
                body += "; filename=\"\(paramSrc)\"\r\n"
                  + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            } catch {
                print("error")
            }

        }
      }
    }
    body += "--\(boundary)--\r\n";
    let postData = body.data(using: .utf8)

    var request = URLRequest(url: URL(string: "http://192.168.0.23/post_fridge_item.php")!,timeoutInterval: Double.infinity)
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
}

////MARK: Post Item In Fridge
//func postFridgeItem(itemName: String, quantity: Int, barcodeValue: String, category: String, completionHandler: @escaping(Bool?, String?) -> Void) {
//    guard let url = URL(string: "http://192.168.0.23/post_fridge_item.php") else { return }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//
//    let parameters = [
//        "item_name": itemName,
//        "quantity": quantity,
//        "barcode_value": barcodeValue,
//        "category": category
//
//    ] as [String : Any]
//
////    let parameters = [
////      [
////        "key": "item_name",
////        "value": itemName,
////        "type": "text"
////      ],
////      [
////        "key": "quantity",
////        "value": quantity,
////        "type": "text"
////      ],
////      [
////        "key": "barcode_value",
////        "value": barcodeValue,
////        "type": "text"
////      ],
////      [
////        "key": "category",
////        "value": category,
////        "type": "text"
////      ]] as [[String : Any]]
////
//    let postData = try? JSONSerialization.data(withJSONObject: parameters)
//    request.httpBody = postData
//
//    let session = URLSession.shared
//
//    let task = session.dataTask(with: request) { data, response, error in
//        guard error == nil else {
//            print(error as? String ?? "")
//            return
//        }
//        guard let data = data else {
//            return
//        }
//        if let httpResponse = response as? HTTPURLResponse {
//            print("*** HTTP STATUS CODE: \(httpResponse.statusCode)")
//
//            if (httpResponse.statusCode == 503) { //service unavailable
//                completionHandler(false, "STATUS 503: Cannot connect to API...")
//                return
//            } else if (httpResponse.statusCode == 401) { //unauthorized
//                completionHandler(false, "STATUS 401: Unauthorized...")
//                return
//            } else if (httpResponse.statusCode != 200) {
//                completionHandler(false, nil)
//                return
//            }
//        } else {
//            completionHandler(false, nil)
//            return
//        }
//
//        do {
//            print("Was it a success?")
//            print(response)
//            print(error)
//            print(data)
//            completionHandler(true, "Success")
//        }
//    }
//    task.resume()
//    return
//}

//MARK: Remove Item From Fridge
func removeItemFromFridge(id: Int, completionHandler: @escaping(Bool?, String?) -> Void) {
    guard let url = URL(string: "http://192.168.0.23/remove_item_from_fridge.php") else { return }
    
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
    guard let url = URL(string: "http://192.168.0.23/update_item_in_fridge.php") else { return }
    
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
    guard let url = URL(string: "http://192.168.0.23/grab_all_fridge_items.php") else { return }
    
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
            
            if Globals.filteredCurrentFridgeInventory.count != 0 {
                Globals.filteredCurrentFridgeInventory.removeAll()
            }
            
            if Globals.currentFridgeInventory.count != 0 {
                Globals.currentFridgeInventory.removeAll()
            }
            
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

//MARK: Extension Functions
extension UIViewController {
    
    //MARK: UI Style Colors
    public func establishUIStyle(tbController: UITabBarController?, labels:[UILabel]?,buttons:[UIButton]?, textFields:[UITextField]?, segmentControl:[UISegmentedControl]?){
        
        
        
        for items in buttons ?? []{
            items.layer.cornerRadius = 5
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            
            tbController?.view.tintColor = UIColor.black
            tbController?.tabBar.barTintColor = UIColor.white
            self.view.backgroundColor = UIColor.white
            for items in labels ?? []{
                items.textColor = UIColor.black
            }
            for items in textFields ?? []{
                items.textColor = UIColor.black
                items.backgroundColor = UIColor.white
                items.layer.borderWidth = 1
                items.layer.borderColor = UIColor.black.cgColor
            }
            for items in segmentControl ?? []{
                items.tintColor = UIColor.black
                items.selectedSegmentTintColor = UIColor.black
                items.backgroundColor = UIColor.gray
            }

        } else {
            self.view.backgroundColor = UIColor.black
            for items in labels ?? []{
                items.textColor = UIColor.white
            }
            for items in textFields ?? []{
                items.textColor = UIColor.white
                items.backgroundColor = UIColor.white
                items.layer.borderWidth = 1
                items.layer.borderColor = UIColor.white.cgColor
            }
            for items in segmentControl ?? []{
                items.tintColor = UIColor.white
                items.backgroundColor = UIColor.white
                items.selectedSegmentTintColor = UIColor.gray
            }
        }

    }

}
