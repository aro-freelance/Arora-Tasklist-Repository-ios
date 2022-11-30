//
//  Category.swift
//  AroraTasklist
//
//  Created by Mandy on 11/30/22.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objc dynamic var categoryName : String = ""
    
    let tasks = List<Task>()
    
    
    init(name : String){
        
        categoryName = name
    }
    
    
}
