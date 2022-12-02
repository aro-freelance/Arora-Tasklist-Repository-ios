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
        
        setCurrentTaskList(fullTaskList)
        
        currentTaskList = sortByDate(currentTaskList)
        
        setupCategories()
        
        tableView.rowHeight = 120
        
        tableView.reloadData()
        
    }
    
    func deleteCategory(){
        
        if let categoryToDelete : Category = realm.objects(Category.self).first(where: {$0.categoryName == categoryString}){
            if let categoryList = categories{
                
                for category in categoryList{
                    
                    if(category.categoryName == categoryToDelete.categoryName){
                        
                        print("delete loop match")
                        
                        //Delete data from persistent storage
                        do{
                            //open transaction
                            try self.realm.write {
                                self.realm.delete(categoryToDelete)
                                categoryPicker.reloadAllComponents()
                            }
                        } catch {
                            print("Error deleting Category: \(error)")
                        }
                        
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
            //show error feedback to user
            let alert = UIAlertController(title: "Error", message: "Failed to load categories", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if(!toDoListExists){
            
            if let category = realm.objects(Category.self).first(where: {$0.categoryName == "To Do List"}){
             
                do{
                    try realm.write {
                        realm.add(category)
                    }
                    
                } catch {
                    print("Error saving category \(error)")
                    //show error feedback to user
                    let alert = UIAlertController(title: "Error", message: "Failed to save category. \(error)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
        }
        
        if(!completedExists){
            
            if let category = realm.objects(Category.self).first(where: {$0.categoryName == "Completed"}){
             
                do{
                    try realm.write {
                        realm.add(category)
                    }
                    
                } catch {
                    print("Error saving category \(error)")
                    //show error feedback to user
                    let alert = UIAlertController(title: "Error", message: "Failed to save category. \(error)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
        }
        
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
                    //TODO: tell user that the category is empty in a label
                    deleteCatButton.isHidden = false
                    
                    print("delete button show. category string = \(categoryString)")
                    
                }
            }
            //To Do List category empty
            else if (categoryString == "To Do List"){
                //TODO: tell user that category is empty in a label
                deleteCatButton.isHidden = true
                print("delete button hide")
            }
            //completed category empty
            else{
                //TODO: tell user that no tasks are completed in a label
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
                if let completedCat = self.realm.objects(Category.self).first(where: {$0.self.categoryName == "Completed"}){
                    
                    
                    do{

                        try self.realm.write {
                            task.category = "Completed"
                    
                            completedCat.tasks.append(task)
                            
                            self.categoryPicker.reloadAllComponents()

                        }

                    } catch {
                        print("Error editing task \(error)")
                        //show error feedback to user
                        let alert = UIAlertController(title: "Error", message: "Failed to edit task. \(error)", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in

                        }))

                        self.present(alert, animated: true, completion: nil)
                    }
                    
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
        if let completedCat = self.realm.objects(Category.self).first(where: {$0.categoryName == "Completed"}){
            
            
            if let index = completedCat.tasks.firstIndex(of: task){
                
                do{
                    
                    try self.realm.write {
                        task.category = "Completed"
                        completedCat.tasks.remove(at: index)
                        
                        self.categoryPicker.reloadAllComponents()
                        
                    }
                    
                } catch {
                    print("Error deleting task \(error)")
                    //show error feedback to user
                    let alert = UIAlertController(title: "Error", message: "Failed to remove task. \(error)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else{
                print("could not find index of task in completed list matching task to delete")
                //show error feedback to user
                let alert = UIAlertController(title: "Error", message: "Failed to find task to remove.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
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
            //show error feedback to user
            let alert = UIAlertController(title: "Error", message: "Failed to find category", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

}

