//
//  ViewController.swift
//  Todoey
//
//  Created by DJ Satoda on 4/30/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//
// Notes: overarching lesson - associate a property not with a cell but with our data. Check mark should be associated with the task, not the cell

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        loadItems()
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    //MARK: - Tableview Datasource methods
    // These tell tableview what cells should display and how many rows
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        // below if-else block can be refactored with ternary operator >>> cell.accessoryType = item.done == true ? .checkmark : .none
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    // MARK: - Tableview Delegate Methods
    // These get fired whenever we click on any cell in tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)
        print(itemArray[indexPath.row].done)
        
        // can be refactored to: itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    

    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks add item in UI alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
        }
        
        // Adds text field to alert view controller
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item" // sample text in field
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
    //MARK: - Model Manuipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
    
        do {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
        } catch {
        print("Error encoding item array, \(error)")
        }
        
        
        // updates tableview for new rows
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

