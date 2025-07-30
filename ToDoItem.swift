//
//  ToDoItem.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import Foundation
import SwiftData

@Model

class ToDoItem {
    var title: String
//    var isImportant: Bool
    var id = UUID()
    
    init(title: String) {
        self.title = title
//        self.isImportant = isImportant
    }
}
