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
    
    
    @IBOutlet weak var calendarPicker: UIDatePicker!
    
    @IBOutlet weak var taskText: UITextView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var categoryText: UITextField!
    
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    
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
    
    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func categoryEditStart(_ sender: UITextField) {
        
        addCategoryButton.isHidden = false
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        //TODO: implement save and then go back to MainViewController
        
        
        
        
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        secondVc.modalPresentationStyle = .fullScreen
        self.show(secondVc, sender: true)
        
        print("save pressed")
        
    }
    
    
    func reset(){
        
        //TODO: edittext.text = ""
        //TODO: set radio buttons to unchecked
        
    }
    
    
    
    
    
    
    
    
    
    


}
