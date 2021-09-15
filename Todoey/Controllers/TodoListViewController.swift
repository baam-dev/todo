//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    MARK: - Add New Items
    
        @IBAction func addPressed(_ sender: UIBarButtonItem) {
    
            // init an empty UITextField
            var alertTextFieldInput = UITextField()
    
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let action = UIAlertAction(title: "Add Item", style: .default) { [self] action in
                
                if alertTextFieldInput.text != "" {
                    let newItem = Item(context: self.context)
                    newItem.done = false
                    newItem.title = alertTextFieldInput.text!
                    
                    self.itemArray.append(newItem)
                    saveItems()
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
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error )
        }
    }
    
}

