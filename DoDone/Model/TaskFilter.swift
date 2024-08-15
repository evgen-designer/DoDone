//
//  TaskFilter.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI

enum TaskFilter: String {
    static var allFilters: [TaskFilter] {
        return [.NonCompleted,.Completed,.OverDue,.All]
    }
    
    case All = "All"
    case NonCompleted = "To do"
    case Completed = "Completed"
    case OverDue = "Overdue"
}
