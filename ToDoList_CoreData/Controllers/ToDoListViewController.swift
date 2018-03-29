/*
 Original VC converted to TableViewController by inheritance (name change optional, but for clarity, did so) and assigning this as the class for the TableViewController in the storyboard.
 NO @IBOutlet needed to connect the table, as it is prepackaged into the TVC.
 */

import UIKit

class ToDoListViewController: UITableViewController {
    
    //    var listArray = [String]()  //array to hold cell data (ToDos)
    var listArray = [Item]()       //change to have custom item so we can associate properties with it, in this case, the checkmark.  since we reuse cells, it appears in the reused cell if in top cell, so we want to be able to associate it with the data, not the cell.
    
    
    //1. To use NSCoder to store data, first create file path do .plist directory
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoListItems.plist")
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoListItems.plist")
    
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    override func viewDidLoad() {
        super.viewDidLoad()
        //since using TableViewController, no need to set self as delegate for TableViewDelegate and TableViewDataSource
        
        //at the start, populate array to test things out
        //listArray.append("test1"); listArray.append("test2"); listArray.append("test3")
        var item1 = Item(); item1.title = "item1"
        
        //        loadDataFromUserDefault()
        print (dataFilePath)
        loadItemsFromPList()
    }
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodf
    
    
    
    
    //MARK: - TableView DataSource Methods:  two required.  cellForRowAt and numberOfRowsInSection
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Here, we cast to the CustomMessageCell type because using the custom cell....since default prototype, no cast as in Chat.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let item = listArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //check hidden/shown depending on state of .done property
        if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        //the above could be shortened by using ternary operator
        //        item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        //        or
        //        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }//end cellForRowAt
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    
    //MARK: - TableView Delegate Methods:
    //this functon detects which row/cell user selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)    //this makes highlight go away after clicking on cell
        
        //Toggle .done in Item (checkmark)
        listArray[indexPath.row].done = !listArray[indexPath.row].done  //replaces if/then below
        
        saveItemsToPList()
        
        
    }//end didSelectRowAt
    
    
    //MARK: - ADD NEW ITEM TO LIST
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        addNewItem()
    }
    
    func addNewItem (){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type in New Item Here"
            textField = alertTextField
        }//end addTextField
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let userInput = textField.text {
                var newItem = Item()
                newItem.title = userInput
                
                self.listArray.append(newItem)
                self.tableView.reloadData()
                //                self.saveDataToUserDefault()
                self.saveItemsToPList()
            }else {
                print ("nothing entered")
            }//end if-else
            
        }//end action
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }//end addNewItem
    
    
    
    //MARK: - save data via NSCoder
    func saveItemsToPList(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(listArray)
            try data.write(to: dataFilePath!)
        }catch {
            print ("Error encoding listArray: \(error)")
        }
        
        tableView.reloadData()
    }//end save data
    
    //MARK: - load data saved via NSCoder
    func loadItemsFromPList(){
        let decoder = PropertyListDecoder()
        
        //get data.  Data() may throw, try.  Angela showed a way to combine optional binding with try statement
                if let data = try? Data(contentsOf: dataFilePath!){
                    do {
                        listArray = try decoder.decode([Item].self, from: data)
                    }catch {
                        print ("Error decoding listArray: \(error)")
                    }
                }//end optional binding
        
//        do {
//            let data = try Data(contentsOf: dataFilePath!)
//            listArray = try decoder.decode([Item].self, from: data)
//        }catch{
//            //print ("Error decoding listArray: \(error)")
//        }
        
        
    }//end load data
    
  
    
}//end class


