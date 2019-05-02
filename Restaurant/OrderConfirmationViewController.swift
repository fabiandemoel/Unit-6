//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Fabian de Moel on 09/02/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes."
    }
}
