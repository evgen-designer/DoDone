//
//  TaskItemExtension.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI

extension TaskItem {
    
    func isCompleted() -> Bool {
        return completedDate != nil
    }
    
    func isOverdue() -> Bool {
        if let due = dueDate {
            return !isCompleted() && scheduleTime && due < Date()
        }
        return false
    }
    
    func overDueColor() -> Color {
        return isOverdue() ? .red : .secondary
    }
    
    func dueDateTimeOnly() -> String {
        if let due = dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: due)
        }
        
        return ""
    }
}
