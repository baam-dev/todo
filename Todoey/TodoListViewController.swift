//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Tyska1", "Dari1", "PRO1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
//    MARK: - Add New Items
    
        @IBAction func addPressed(_ sender: UIBarButtonItem) {
    
            // init an empty UITextField
            var alertTextFieldInput = UITextField()
    
            let alert = UIAlertController(title: "Add New Course", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let action = UIAlertAction(title: "Add Item", style: .default) { action in
                // what will happen once user clicks the add btn
    
                self.itemArray.append(alertTextFieldInput.text!)
                self.tableView.reloadData()
    
            }
    
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "e.g. Math 2"
                alertTextFieldInput = alertTextField
            }
            // 1. create alert
            // 2. create action
            // 3. add the action to alert
            // 4. present the alert (includes the action)
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    

    
}

