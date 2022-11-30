//
//  ViewController.swift
//  AroraTasklist
//
//  Created by Mandy on 11/30/22.
//

import UIKit
import RealmSwift

/*
 this will show the tableview of tasks. it will have a dropdown to select categories (which will update which tasks are shown). equivalent of MainActivity in Android project.
 */

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteCatButton: UIButton!
    
    var categoryString : String = ""
    var category : Category = Category()
    
    let realm = try! Realm()
    var currentTaskList = [Task]()
    var fullTaskList : Results<Task>?
    
    var categories : Results<Category>?
    
    var isLoadingFromDelete = false
    
    var isEdit = false
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        setCurrentTaskList(fullTaskList)
        
        currentTaskList = sortByDate(currentTaskList)
        
        setupCategories()
        
        tableView.reloadData()
        
    }
    
    func deleteCategory(){
        
        var categoryToDelete : Category = category
        
        if let categoryList = categories{
            
            for category in categoryList{
             
                if(category.categoryName == categoryToDelete.categoryName){
                    
                    categories?.realm?.delete(categoryToDelete)
    
                }
            }
        }
    }
    
    
    @IBAction func deleteCatButtonPressed(_ sender: UIButton) {
        
        //show a dialog to confirm that user wants to delete. if they do call deleteCategory
        let alert = UIAlertController(title: "Delete", message: "Are you sure that you want to delete this category?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak alert] (_) in
            print("delete method called")
            self.deleteCategory()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            print("delete canceled")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func setupCategories(){
        
        categories = realm.objects(Category.self)
        
        var toDoListExists = false
        var completedExists = false
        
        if let categoryList = categories{
            
            for category in categoryList{
             
                if(category.categoryName == "To Do List"){
                    
                    toDoListExists = true
    
                }
                
                if(category.categoryName == "Completed"){
                    
                    completedExists = true
    
                }
            }
        }
        else{
            print("Main: failed to get categories from realm")
        }
        
        if(!toDoListExists){
            
            var category = Category()
            category.categoryName = "To Do List"
            
            do{
                try realm.write {
                    realm.add(category)
                }
                
            } catch {
                print("Error saving category \(error)")
                //TODO: show user the feedback
            }
            
        }
        
        if(!completedExists){
            
            var category = Category()
            category.categoryName = "Completed"
            
            do{
                try realm.write {
                    realm.add(category)
                }
                
            } catch {
                print("Error saving category \(error)")
                //TODO: show user the feedback
            }
            
        }
        
        print("categories: \(categories)")
        
        //TODO: set the categorylist to the category picker
        
        
        if(isLoadingFromDelete){
            //TODO: set the category picker to show completed list
            
            isLoadingFromDelete = false
            
        }
        else{
            //TODO: set the category picker to the first item
        }
        
        
    }
    
    func setCurrentTaskList(_ tasks : Results<Task>?){
        
        currentTaskList.removeAll()
        
        //for the full list of tasks
        if let taskList = fullTaskList{
            for task in taskList{
             
                //if the task matches the selected category
                if(task.category == categoryString){
                    
                    //add it to the currentTaskList
                    currentTaskList.append(task)
                }
                
                
            }
        }
        
        //there are tasks in the current list
        if(currentTaskList.count > 0){
            deleteCatButton.isHidden = true
        }
        // there are not tasks in the current list
        else{
            
            //if the category is not a default category and is empty show the delete category button
            if(categoryString != nil){
                if(categoryString != "To Do List" && categoryString != "Completed"){
                    //TODO: display feedback to user telling them that the category is empty
                    deleteCatButton.isHidden = false
                    
                }
            }
            //To Do List category empty
            else if (categoryString == "To Do List"){
                //TODO: display feedback to user telling them that the category is empty
                deleteCatButton.isHidden = true
            }
            //completed category empty
            else{
                //TODO: display feedback to user that there are no completed tasks
                deleteCatButton.isHidden = true
            }
            
        }
        
    }
    
    
    
    func sortByDate(_ tasks : [Task]) -> [Task]{
        
        return tasks.sorted(by: { $0.dueDate > $1.dueDate })
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "WriteTaskViewController") as! WriteTaskViewController
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
        
    }
    
    
    
    //picker methods
    //TODO: picker item selected (change category)
    
    
    
///MARK: Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentTaskList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = currentTaskList[indexPath.row]
        
        cell.textLabel?.text = task.taskString
        
        //TODO: method for checkmark clicked in Android reference onTaskRadioButtonClicked
        cell.accessoryType = task.isDone ? .checkmark : .none
        
        //TODO: show date in a better way?
        cell.detailTextLabel?.text = task.dueDate.description
        
        var priorityColor : UIColor = .gray
        
        //TODO: test better colors
        if(task.priorityString == "LOW"){
            priorityColor = .blue
        } else if(task.priorityString == "MEDIUM"){
            priorityColor = .systemYellow
        } else if(task.priorityString == "HIGH"){
            priorityColor = .systemRed
        } else{
            priorityColor = .white
        }
    
        cell.backgroundColor = priorityColor
       
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "WriteTaskViewController") as! WriteTaskViewController
        
        secondVc.isEdit = true
        secondVc.taskToEdit = currentTaskList[indexPath.row]
        
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
        
    }
    
    

}

