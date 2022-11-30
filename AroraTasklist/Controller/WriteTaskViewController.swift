//
//  WriteTaskViewController.swift
//  AroraTasklist
//
//  Created by Mandy on 11/30/22.
//

import UIKit
import RealmSwift

/*
 this will be the controller for making new tasks and editing tasks. It is the equivalent of BottomSheetFragment in the Android project.
 */

class WriteTaskViewController: UIViewController {
    
    @IBOutlet weak var calendarPicker: UIDatePicker!
    
    @IBOutlet weak var taskText: UITextView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var categoryText: UITextField!
    
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let realm = try! Realm()
    
    
    var priorityString : String?
    
    var dueDate : Date?
    
    var isEdit = false
    
    var categoryString : String?
    
    //var categoryStrings = [String]()
    
    var categoriesFull : Results<Category>?
    
    var categories = [Category]()
    
    var taskToEdit = Task()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        taskText.text = taskToEdit.taskString
        
        setupCategories()
        
    }
    
  
    
    func setupCategories(){
        
        categories.removeAll()
        
        categoriesFull = realm.objects(Category.self)
        
        var toDoListExists = false
        var completedExists = false
        
        //TODO: test and fix this. categoriesFull is nil later when we are saving.
        //might be best to just not turn it into an array list.  find a way to pull the data out and make a list of strings instead.
        
        
        if let categoryList = categoriesFull{
            
            for category in categoryList{
             
                if(category.categoryName == "To Do List"){
                    
                    print("to do list exists")
                    toDoListExists = true
    
                }
                
                if(category.categoryName == "Completed"){
                    
                    print("completed exists")
                    completedExists = true
    
                }
                
            }
            
            if(toDoListExists){
                print("filling list without adding to do list")
                for category in categoryList {
                    
                    categories.append(category)
                    
                }
            }
            else{
                print("filling list adding to do list")
                var toDoCat = Category()
                toDoCat.categoryName = "To Do List"
                
                categories.append(toDoCat)
                
                for category in categoryList {
                    categories.append(category)
                }
            }
            
            //if the completed category exists
            if(completedExists){
                //find the index for it
                if let index = categories.firstIndex(where: { $0.categoryName == "Completed"}){
                    //and remove it (we do not want it to display as an option to add tasks to)
                    categories.remove(at: index)
                }
            }
            
            print("categories: \(categories)")
            
        } else{
            print("WriteVC: failed to get category list from realm")
        }
        
        
        //TODO: set the categorylist to the category picker
        
    }
    
    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {
        
        //if we have user input
        if let userCategoryInput = categoryText.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            if(!userCategoryInput.isEmpty){
                
                //make a category from it
                var newCategory = Category()
                newCategory.categoryName = userCategoryInput
                //add it to the list
                categories.append(newCategory)
                
                //TODO: update the category picker
                
                //TODO: set the category picker to display the newly added category
                
                //set the category string to the user input
                categoryString = userCategoryInput
                
                //reset the edit text
                categoryText.text = ""
            
            }
            //we obtained an empty string from the user
            else{
                print("empty category string submitted")
                
                //TODO: feedback to user that they cannot enter an empty string as a category
                
            }
        }
        
        //make the button for submitting categories invisible again
        addCategoryButton.isHidden = true
        
    }
    
    //the user is typing in the category edittext box
    @IBAction func categoryEditStart(_ sender: UITextField) {
        
        //user is entering a category. show them the button to submit it.
        addCategoryButton.isHidden = false
        print("editing category text. button should show.")
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        //TODO: implement save and then go back to MainViewController
        
        var taskString = taskText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        if(taskString == nil){
//            taskString = ""
//            print("task string was nil. setting to empty string")
//        }
        
        if(dueDate == nil){
            if(isEdit){
                dueDate = taskToEdit.dueDate
            }
            else{
                dueDate = Date()
            }
        }
        
        if(priorityString == nil){
            if(isEdit){
                priorityString = taskToEdit.priorityString
            }
            else{
                priorityString = "LOW"
            }
        }
        
        if(categoryString == nil){
            if(isEdit){
                categoryString = taskToEdit.category
            }
            else{
                categoryString = "To Do List"
            }
        }
        
        var category = Category()
        category.categoryName = categoryString!
        
        var newTask = Task()
        newTask.taskString = taskString
        newTask.dueDate = dueDate!
        newTask.priorityString = priorityString!
        newTask.category = categoryString!
        
        
        //if the category does not exist, save it to realm db
        if let safeCategoriesFull = categoriesFull{
            if(!(safeCategoriesFull.contains(where: {$0.categoryName == categoryString}))){
                do{
                    try realm.write {
                        realm.add(category)
                    }
                    
                } catch {
                    print("Error saving category \(error)")
                    //TODO: show user the feedback
                }
            }
        } else{
            print("categories full is nil. cannot write new category")
            //TODO: show user that saving failed
        }
        
        
        //editing a task
        if(isEdit){
            
            taskToEdit.taskString = taskString
            taskToEdit.dueDate = dueDate!
            taskToEdit.priorityString = priorityString!
            taskToEdit.category = categoryString!
            taskToEdit.isDone = false
            
            
            do{
                try self.realm.write {
                    
                    category.tasks.append(taskToEdit)
                    
                    goToMainScreen()
                }
                
            } catch {
                print("Error editing task \(error)")
                //TODO: show user the feedback
            }
            
        }
        //new task creation
        else{
            
            
            do{
                try self.realm.write {
                    
                    category.tasks.append(newTask)
                    
                    goToMainScreen()
                }
                
            } catch {
                print("Error saving new task \(error)")
                //TODO: show user the feedback
            }
            
            
        }
        
        
    }
    
    func goToMainScreen(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
    }
    
    


}
