//
//  Task.swift
//  AroraTasklist
//
//  Created by Mandy on 11/30/22.
//

import Foundation
import RealmSwift

class Task : Object {
    
    @objc dynamic var taskString : String = ""
    
    //save this as a string and convert it back later
    @objc dynamic var priorityString : String = "LOW"
    
    @objc dynamic var category : String = ""
    
    @objc dynamic var dueDate : Date = Date()
    
    @objc dynamic var dateCreated : Date = Date()
    
    @objc dynamic var isDone : Bool = false
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
    
    
}
