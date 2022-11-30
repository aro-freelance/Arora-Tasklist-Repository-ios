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
    
    var categories = [Category]()
    
    var isLoadingFromDelete = false
    
    var isEdit = false
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        setCurrentTaskList(fullTaskList)
        
        sortByDate(currentTaskList)
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func deleteCatButtonPressed(_ sender: UIButton) {
        
        //TODO: implement
        
    }
    
    func deleteCategory(){
        
        //TODO: implement
        
    }
    
    func getCategories(_ categoryList : [Category]){
        
        //TODO: implement
        
    }
    
    func setCurrentTaskList(_ tasks : Results<Task>?){
        
        //TODO: implement
        
    }
    
    func sortByDate(_ tasks : [Task]){
        
        
    }
    
    //add button method
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "WriteTaskViewController") as! WriteTaskViewController
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
        
    }
    
    
    
    func showWriteTaskScreen(){
        
        //TODO: implement
        
        //TODO: send isEdit, task
        
    }
    
    
    
    //spinner methods
    //TODO: spinner item selected
    
    
    
    //radio button
    //TODO: radio button clicked method
    
    
    
///MARK: Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentTaskList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = currentTaskList[indexPath.row]
        
        cell.textLabel?.text = task.taskString
        
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
        secondVc.task = currentTaskList[indexPath.row]
        
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
        
    }
    
    

}

