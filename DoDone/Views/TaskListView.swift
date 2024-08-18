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
    @State var editingList = false
    
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
                            .onMove(perform: { indices, newOffset in
                                moveTask(from: indices, to: newOffset, in: 0)
                            })
                            .onLongPressGesture {
                                withAnimation {
                                    self.editingList = true
                                }
                            }
                        }
                        .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
                        
                        Section(header: Text("Completed")) {
                            ForEach(completedTasks()) { taskItem in
                                NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: taskItem.dueDate!).environmentObject(dateHolder)) {
                                    TaskCell(passedTaskItem: taskItem)
                                        .environmentObject(dateHolder)
                                }
                            }
                            .onDelete(perform: deleteItems)
                            .onMove(perform: { indices, newOffset in
                                moveTask(from: indices, to: newOffset, in: 1)
                            })
                            .onLongPressGesture {
                                withAnimation {
                                    self.editingList = true
                                }
                            }
                        }
                        .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
                    }
                    
                    FloatingButton()
                        .environmentObject(dateHolder)
                }
            }
            .navigationTitle(formattedMonthTitle())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func moveTask(from source: IndexSet, to destination: Int, in section: Int) {
        // Determine the tasks to reorder based on the section
        var tasksToReorder: [TaskItem] = section == 0 ? todoTasks() : completedTasks()
        
        // Perform the reordering
        tasksToReorder.move(fromOffsets: source, toOffset: destination)
        
        // Update the order for each task
        for (index, task) in tasksToReorder.enumerated() {
            task.order = Int16(index)
        }
        
        withAnimation {
            self.editingList = false
        }
        
        // Save the context
        dateHolder.saveContext(viewContext)
        
        // Refresh the task items to ensure the UI updates correctly
        dateHolder.refreshTaskItems(viewContext)
    }
    
    private func formattedMonthTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: dateHolder.date)
    }
    
    private func todoTasks() -> [TaskItem] {
        return dateHolder.taskItems.filter { !$0.isCompleted() }.sorted {
            if $0.created == $1.created {
                return $0.order < $1.order
            }
            return $0.created! > $1.created!
        }
    }

    private func completedTasks() -> [TaskItem] {
        return dateHolder.taskItems.filter { $0.isCompleted() }.sorted {
            if $0.completedDate == $1.completedDate {
                return $0.order < $1.order
            }
            return $0.completedDate! > $1.completedDate!
        }
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
