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

class TaskCell : UITableViewCell{
    
    var closure: (()->())?
    
    @IBOutlet weak var taskCellButton: UIButton!
    
    @IBOutlet weak var taskCellText: UILabel!
    
    @IBOutlet weak var taskCellDateLabel: UILabel!
    
    @IBAction func cellButtonPressed(_ sender: UIButton) {
        closure?()
    }
    
}


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteCatButton: UIButton!
    
    var categoryString : String = "To Do List"
    var category : Category = Category()
    
    let realm = try! Realm()
    var currentTaskList = [Task]()
    var fullTaskList : Results<Task>?
    
    var categories : Results<Category>?
    
    var isLoadingFromDelete = false
    
    var isEdit = false
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fullTaskList = realm.objects(Task.self)
        
        print("full list count: \(fullTaskList?.count ?? 0)")
        
        setCurrentTaskList(fullTaskList)
        
        currentTaskList = sortByDate(currentTaskList)
        
        setupCategories()
        
        tableView.rowHeight = 120
        
        tableView.reloadData()
        
    }
    
    func deleteCategory(){
        
        var categoryToDelete : Category = category
        
        if let categoryList = categories{
            
            for category in categoryList{
                
                print("delete loop. \(category.categoryName)")
             
                if(category.categoryName == categoryToDelete.categoryName){
                    
                    print("delete loop match")
                    
                    //Delete data from persistent storage
                    do{
                        //open transaction
                        try self.realm.write {
                            self.realm.delete(category)
                            categoryPicker.reloadAllComponents()
                        }
                    } catch {
                        print("Error deleting Category: \(error)")
                    }
    
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
        
        print("set current task list")
        
        //for the full list of tasks
        if let taskList = fullTaskList{
            for task in taskList{
             
                //if the task matches the selected category
                if(task.category == categoryString){
                    
                    print("add task \(task.taskString) to current list")
                    
                    //add it to the currentTaskList
                    currentTaskList.append(task)
                }
                
                
            }
        } else{
            print("set current task list: failed to make list from full task list")
        }
        
        print("current task list count = \(currentTaskList.count)")
        
        //there are tasks in the current list
        if(currentTaskList.count > 0){
            deleteCatButton.isHidden = true
            print("delete button hide")
            
        }
        // there are not tasks in the current list
        else{
            
            //if the category is not a default category and is empty show the delete category button
            if(categoryString != nil){
                if(categoryString != "To Do List" && categoryString != "Completed"){
                    //TODO: display feedback to user telling them that the category is empty
                    deleteCatButton.isHidden = false
                    
                    print("delete button show. category string = \(categoryString)")
                    
                }
            }
            //To Do List category empty
            else if (categoryString == "To Do List"){
                //TODO: display feedback to user telling them that the category is empty
                deleteCatButton.isHidden = true
                print("delete button hide")
            }
            //completed category empty
            else{
                //TODO: display feedback to user that there are no completed tasks
                deleteCatButton.isHidden = true
                print("delete button hide")
            }
            
        }
        
        tableView.reloadData()
        
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
    
    
    
    
///MARK: Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("number on rows: \(currentTaskList.count)")
        
        return currentTaskList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        //tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = currentTaskList[indexPath.row]
        
        cell.taskCellText.text = task.taskString
        
        //TODO: make this into a more user friendly format
        cell.taskCellDateLabel.text = task.dueDate.description
        
        cell.closure = {
            
            //if category is not completed, move task to completed
            if(self.categoryString != "Completed"){
                do{
                    print("move task to Completed")
                    var completedCat = Category()
                    completedCat.categoryName = "Completed"

                    task.category = "Completed"

                    try self.realm.write {
                        completedCat.tasks.append(task)

                    }

                } catch {
                    print("Error editing task \(error)")
                    //TODO: show user the feedback
                }
            }
            //category is completed, prompt user to delete task
            else{

                //show a dialog to confirm that user wants to delete. if they do call delete()
                let alert = UIAlertController(title: "Delete", message: "Are you sure that you want to delete this?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak alert] (_) in
                    print("delete method called")
                    self.delete(task: task)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                    print("delete canceled")
                }))

                self.present(alert, animated: true, completion: nil)

            }
            
            
        }
       
        var priorityColor : UIColor = .gray

        //TODO: test better colors
        if(task.priorityString == "LOW"){
            priorityColor = .systemBlue
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
    
    func delete(task: Task){
        //delete task
        
        print("delete task")
        var completedCat = Category()
        completedCat.categoryName = "Completed"
        
        task.category = "Completed"
        
        if let index = completedCat.tasks.firstIndex(of: task){
            
            do{
                
                try self.realm.write {
                    
                    completedCat.tasks.remove(at: index)
                    
                }
                
            } catch {
                print("Error editing task \(error)")
                //TODO: show user the feedback
            }
            
        } else{
            print("could not find index of task in completed list matching task to delete")
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "WriteTaskViewController") as! WriteTaskViewController
        
        secondVc.isEdit = true
        secondVc.taskToEdit = currentTaskList[indexPath.row]
        
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories?[row].categoryName ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let string = categories?[row].categoryName {
            
            categoryString = string
            category.categoryName = categoryString
            
            print("category string = \(categoryString)")
            
            setCurrentTaskList(fullTaskList)
            
            currentTaskList = sortByDate(currentTaskList)
            
            tableView.reloadData()
            
            
        }
        else{
            
            print("category selected could not be obtained")
        }
        
        
    }

}

