//
//  ToDoItem.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import Foundation

class ToDoItem {
    var title: String
    var id = UUID()
    
    init(title: String) {
        self.title = title
    }
}
