//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 80
        
        loadItems()
    }

    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
//        cell.accessoryType = item.done == true ? .checkmark : .none
        cell.delegate = self
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
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
    
    
    // method with external and a internal input, witha default value that will be used when
    // call th function without an input
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error )
        }
        tableView.reloadData()
    }
    
}
//MARK: - UISearchBar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // manages the order of executions
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
//MARK: - SwipeCell Delegate Methods
extension TodoListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
            // handle action by updating model with deletion
            context.delete(itemArray[indexPath.row])
                itemArray.remove(at: indexPath.row)
                //            self.saveItems()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon2")
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
      
        options.expansionStyle = .destructive
//        options.transitionStyle = .border
        return options
    }
    
}
