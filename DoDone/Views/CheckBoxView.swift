//
//  CheckBoxView.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI

struct CheckBoxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    
    var body: some View {
        Image(systemName: passedTaskItem.isCompleted() ? "checkmark.circle.fill" : "circle")
            .foregroundColor(passedTaskItem.isCompleted() ? .green : .secondary)
            .onTapGesture {
                withAnimation {
                    if passedTaskItem.isCompleted() {
                        // Mark the task as incomplete (move it back to "To do")
                        passedTaskItem.completedDate = nil
                        passedTaskItem.order = 0
                        
                        // Reorder existing incomplete tasks
                        let incompleteTasks = dateHolder.taskItems.filter { !$0.isCompleted() && $0 != passedTaskItem }
                        for (index, task) in incompleteTasks.enumerated() {
                            task.order = Int16(index + 1)
                        }
                    } else {
                        // Mark the task as complete
                        passedTaskItem.completedDate = Date()
                        passedTaskItem.order = 0
                        
                        // Reorder existing complete tasks
                        let completeTasks = dateHolder.taskItems.filter { $0.isCompleted() && $0 != passedTaskItem }
                        for (index, task) in completeTasks.enumerated() {
                            task.order = Int16(index + 1)
                        }
                    }
                    
                    // Save the context and refresh the task items
                    dateHolder.saveContext(viewContext)
                    dateHolder.refreshTaskItems(viewContext)
                }
            }
    }
}

//#Preview {
//    CheckBoxView(passedTaskItem: TaskItem(context: PersistenceController.preview.container.viewContext))
//        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
//}
