//
//  Task.swift
//  todo_proj copy
//
//  Created by Scholar on 7/31/25.
//


//
//  Task.swift
//  todo_proj
//
//  Created by Scholar on 7/30/25.
//

import Foundation

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
}
