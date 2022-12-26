//
//  ViewController.swift
//  ToDoList
//
//  Created by Sévio Basilio Corrêa on 10/12/22.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
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
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        }
    }
    
    // MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Adicione novo item", message: "", preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Adicionar item", style: .default) { action in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "Novo Item"
            newItem.done = false
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
        
        do {
            
            
            try context.save()
        } catch {
            print("Error saving Context. \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching Data from context. \(error)")
        }
        
    }
    
}

