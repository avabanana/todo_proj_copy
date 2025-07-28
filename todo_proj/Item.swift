//
//  Item.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
