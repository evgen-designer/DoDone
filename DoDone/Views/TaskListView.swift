//
//  TaskListView.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        NavigationView {
            VStack {
                WeeklyCalendarView()
                    .padding()
                    .environmentObject(dateHolder)

                ZStack {
                    List {
                        Section(header: Text("To do")) {
                            ForEach(todoTasks()) { taskItem in
                                NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: taskItem.dueDate!).environmentObject(dateHolder)) {
                                    TaskCell(passedTaskItem: taskItem)
                                        .environmentObject(dateHolder)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        
                        Section(header: Text("Completed")) {
                            ForEach(completedTasks()) { taskItem in
                                NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: taskItem.dueDate!).environmentObject(dateHolder)) {
                                    TaskCell(passedTaskItem: taskItem)
                                        .environmentObject(dateHolder)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                    
                    FloatingButton()
                        .environmentObject(dateHolder)
                }
            }
            .navigationTitle("Todo list")
        }
    }
    
    private func todoTasks() -> [TaskItem] {
        dateHolder.taskItems.filter { !$0.isCompleted() }
    }
    
    private func completedTasks() -> [TaskItem] {
        dateHolder.taskItems.filter { $0.isCompleted() }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoTasks()[$0] }.forEach(viewContext.delete)
            offsets.map { completedTasks()[$0] }.forEach(viewContext.delete)
            
            dateHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    TaskListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
}
