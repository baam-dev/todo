//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Apples", "Oranges", "Strawberries"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
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
    
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let action = UIAlertAction(title: "Add Item", style: .default) { action in
                
                // what will happen once user clicks the add btn
                // if there is no text, do not run
                if alertTextFieldInput.text != "" {
                    self.itemArray.append(alertTextFieldInput.text!)
                    
                    self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
                    self.tableView.reloadData()
                }
            }
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "e.g. Egg"
                alertTextField.autocapitalizationType = .words
                    alertTextFieldInput = alertTextField
            }
            
            
            
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    

    
}

