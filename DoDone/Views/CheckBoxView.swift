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
                    if !passedTaskItem.isCompleted() {
                        passedTaskItem.completedDate = Date()
                        dateHolder.saveContext(viewContext)
                    }
                }
            }
    }
}

//#Preview {
//    CheckBoxView(passedTaskItem: TaskItem(context: PersistenceController.preview.container.viewContext))
//        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
//}
