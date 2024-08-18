//
//  TaskEditView.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedTaskItem: TaskItem?
    @State var name: String
    @State var desc: String
    @State var dueDate: Date
    @State var scheduleTime: Bool
    
    init(passedTaskItem: TaskItem?, initialDate: Date) {
        if let taskItem = passedTaskItem {
            _selectedTaskItem = State(initialValue: taskItem)
            _name = State(initialValue: taskItem.name ?? "")
            _desc = State(initialValue: taskItem.desc ?? "")
            _dueDate = State(initialValue: taskItem.dueDate ?? initialDate)
            _scheduleTime = State(initialValue: taskItem.scheduleTime)
        } else {
            _name = State(initialValue: "")
            _desc = State(initialValue: "")
            _dueDate = State(initialValue: initialDate)
            _scheduleTime = State(initialValue: false)
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Task name", text: $name)
                TextField("Description", text: $desc)
            }
            
            Section(header: Text("Due date")) {
                Toggle("Schedule time", isOn: $scheduleTime)
                DatePicker("Due date", selection: $dueDate, displayedComponents: displayComps())
            }
            
            if selectedTaskItem?.isCompleted() ?? false {
                Section(header: Text("Completed")) {
                    Text(selectedTaskItem?.completedDate?.formatted(date: .abbreviated, time: .shortened) ?? "")
                        .foregroundColor(.green)
                }
            }
            
            Section() {
                Button("Save", action: saveAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    func displayComps() -> DatePickerComponents {
        return scheduleTime ? [.hourAndMinute, .date] : [.date]
    }
    
    func saveAction() {
        withAnimation {
            if selectedTaskItem == nil {
                selectedTaskItem = TaskItem(context: viewContext)
                selectedTaskItem?.created = Date()
                selectedTaskItem?.order = 0
                
                // Reorder existing tasks
                let existingTasks = dateHolder.taskItems.filter { !$0.isCompleted() }
                for (index, task) in existingTasks.enumerated() {
                    task.order = Int16(index + 1)
                }
            }
            
            selectedTaskItem?.name = name
            selectedTaskItem?.desc = desc
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.scheduleTime = scheduleTime
            
            dateHolder.saveContext(viewContext)
            dateHolder.refreshTaskItems(viewContext)
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    TaskEditView(passedTaskItem: TaskItem(context: PersistenceController.preview.container.viewContext), initialDate: Date())
        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
}

