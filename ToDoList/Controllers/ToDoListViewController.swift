//
//  ViewController.swift
//  ToDoList
//
//  Created by Sévio Basilio Corrêa on 10/12/22.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let newItem = Item()
        newItem.title = "Item 1"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Item 2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Item 3"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Item 4"
        itemArray.append(newItem4)
        
        let newItem5 = Item()
        newItem5.title = "Item 5"
        itemArray.append(newItem5)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    // MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        // se item.done = true então cell.accessoryType.checkmark, senão .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Adicione novo item", message: "", preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Adicionar item", style: .default) { action in
            
            let newItem = Item()
            newItem.title = textField.text ?? "Novo Item"
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Digite o novo item"
            textField = alertTextField
        }
        
        
        alert.addAction(actionButton)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding data Array, \(error)")
        }
    }
    
}

