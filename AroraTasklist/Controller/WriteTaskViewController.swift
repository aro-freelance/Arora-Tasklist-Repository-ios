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
    
    //view outlets
    
    
    var priority : Priority = Priority.LOW
    
    var dueDate : Date = Date()
    
    //var calendar : Calendar = Calendar()
    
    var isEdit = false
    
    var categoryString = ""
    
    var categories = [Category]()
    
    var task = Task()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //TODO: set edittext.text to task.task (make get, set methods?)
        
    }
    
    func getCategories(_ categoryList : [Category]){
        
        //TODO: implement
        
    }
    
    func getUserInputCategory(){
        
        //TODO: implement
        
    }
    
    
    //category enter button method
    
    
    
    //category button method
    
    
    //radio button methods
    
    
    
    //priority button method
    
    
    
    //next week chip method
    
    
    
    //tomorrow chip method
    
    
    
    
    //today chip method
    
    
    
    //calendar view method
    
    
    
    //calendar button method
    
    
    
    //save button method
    
    
    
    //spinner selection method
    
    
    func reset(){
        
        //TODO: edittext.text = ""
        //TODO: set radio buttons to unchecked
        
    }
    
    
    
    
    
    
    
    
    
    


}
