//
//  Order.swift
//  Restaurant
//
//  Created by Fabian de Moel on 03/12/2018.
//  Copyright © 2018 Fabian de Moel. All rights reserved.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
