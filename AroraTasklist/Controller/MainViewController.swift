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

class MainViewController: UIViewController {
    
    //view outlets
    
    
    
    
    
    var categoryString : String = ""
    var category : Category = Category()
    
    var currentTaskList = [Task]()
    var fullTaskList = [Task]()
    
    var categories = [Category]()
    
    var isLoadingFromDelete = false
    
    var isEdit = false
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //TODO: load fulltasklist from Realm stored value
        
        setCurrentTaskList(fullTaskList)
        
        sortByDate(currentTaskList)
        
        //TODO: set currentTaskList to the tableview
        
    }
    
    //delete button method
    
    
    
    
    func deleteCategory(){
        
        //TODO: implement
        
    }
    
    func getCategories(_ categoryList : [Category]){
        
        //TODO: implement
        
    }
    
    func setCurrentTaskList(_ tasks : [Task]){
        
        //TODO: implement
        
    }
    
    func sortByDate(_ tasks : [Task]){
        
        
    }
    
    //add button method
    
    
    
    
    
    func showWriteTaskScreen(){
        
        //TODO: implement
        
        //TODO: send isEdit, task
        
    }
    
    
    
    //spinner methods
    //TODO: spinner item selected
    
    
    
    //radio button
    //TODO: radio button clicked method
    
    
    
    //TODO: Tableview adapter methods (and tableview on click method)
    //if something is clicked isEdit = true
    
    

}

