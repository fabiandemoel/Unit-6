//
//  CategoryTableTableViewController.swift
//  Restaurant
//
//  Created by Fabian de Moel on 02/12/2018.
//  Copyright © 2018 Fabian de Moel. All rights reserved.
//

import UIKit

class CategoryTableTableViewController: UITableViewController {
    
    // Attributes
    var categories = [String]()
    
    // Initialize view
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.fetchCategories { (categories) in
            if let categories = categories{
                self.updateUI(with: categories)
            }
        }
    }

    // Update view
    func updateUI(with categories: [String]) {
      DispatchQueue.main.async {
        self.categories = categories
        self.tableView.reloadData()
      }
    }
    
    // Count categories
    override func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // Set cells up
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "CategoryCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    // Name cells
    func configure(_ cell: UITableViewCell, forItemAt indexPath:
        IndexPath) {
        let categoryString = categories[indexPath.row]
        cell.textLabel?.text = categoryString.capitalized
    }
    
    // Hand data to Menu controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue" {
            let menuTableViewController = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
        }
    }
}
