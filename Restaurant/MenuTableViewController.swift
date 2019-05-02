//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Fabian de Moel on 02/12/2018.
//  Copyright © 2018 Fabian de Moel. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    // Attributes
    var menuItems = [MenuItem]()
    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title and items
        title = category.capitalized
        MenuController.shared.fetchMenuItems(forCategory: category)
        { (menuItems) in
            if let menuItems = menuItems {
                print("Found menu items")
                self.updateUI(with: menuItems)
            }
            print("did not find menu items")
        }
    }
    
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    // Number of Cells
    override func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
    indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    // Name and Price
    func configure(_ cell: UITableViewCell, forItemAt indexPath:
        IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {return}
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
    
    // Hand data to Item Detail controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuDetailSegue" {
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }
}
