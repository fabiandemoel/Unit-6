//
//  MenuController.swift
//  Restaurant
//
//  Created by Fabian de Moel on 03/12/2018.
//  Copyright © 2018 Fabian de Moel. All rights reserved.
//

import Foundation
import UIKit

// Networking code
class MenuController {
    
    let baseURL = URL(string: "https://resto.mprog.nl/")!
    
    static let shared = MenuController()
    static let orderUpdatedNotification = Notification.Name("MenuController.oderUpdated")
    
    var order = Order() {
        // Send notification when changed
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    // Request Image
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    // GET for category
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL = baseURL.appendingPathComponent("categories")
        
        // Decoding data
        let task = URLSession.shared.dataTask(with: categoryURL)
        { (data, response, error) in
            if let data = data,
            let jsonDictionary = try?
                JSONSerialization.jsonObject(with: data) as?
                    [String:Any],
            let categories = jsonDictionary?["categories"] as?
                [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    // GET for items within catagory
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        // Decoding data
        let task = URLSession.shared.dataTask(with: menuURL)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    // POST containing user's order
    func submitOrder(forMenuIDs menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Array of menu IDs
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        // Submit Order
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try?
                    jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
