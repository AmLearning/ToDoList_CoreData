//
//  CategoryTableViewController.swift
//  ToDoList_CoreData
//
//  Created by Theodore Schrey on 3/30/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //MARK: - Class Properties
    var categoryArray = [Category]()
    
    //1. To use COREDATA to store data, we reference a context in AppDelegate to add/save/load an Item
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grocery = Category(context: self.context) ; let errands = Category(context: self.context); let misc = Category(context: self.context)
        grocery.name = "grocery"; errands.name = "errands"; misc.name = "misc"
        categoryArray.append(grocery); categoryArray.append(errands); categoryArray.append(misc)

    }
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name

        return cell
    }//en cellForRowAt
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //if cell selected, 
    }
  

    //MARK: - @IBAction

    @IBAction func addCategoryButtonTapped(_ sender: UIBarButtonItem) {
        addNewCategory()
    }
    
    
    func addNewCategory(){
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }//end add textField
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let userInput = textField.text {
                let newCategory = Category(context: self.context)
                newCategory.name = userInput
                
                self.categoryArray.append(newCategory)
                self.tableView.reloadData()
                self.saveItems()
            }//end if
        }//end action
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - save data via CoreData
    func saveItems(){
        
        do{
            try context.save()
        }catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }//end save data
    
    //MARK: - load data saved via CoreData
    func loadItems(){
        let request: NSFetchRequest <Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print ("Error loading context: \(error)")
        }
        tableView.reloadData()
    }//end load data
    

}
