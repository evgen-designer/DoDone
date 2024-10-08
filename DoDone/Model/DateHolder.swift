//
//  DateHolder.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject {
    @Published var date: Date
    @Published var taskItems: [TaskItem] = []
    
    let calendar: Calendar = Calendar.current
    
    init(_ context: NSManagedObjectContext) {
        self.date = Date()
        refreshTaskItems(context)
    }
    
    func moveDate(_ days: Int,_ context: NSManagedObjectContext) {
        date = calendar.date(byAdding: .day, value: days, to: date)!
        refreshTaskItems(context)
    }
    
    func refreshTaskItems(_ context: NSManagedObjectContext) {
        taskItems = fetchTaskItems(context)
    }
    
    func fetchTaskItems(_ context: NSManagedObjectContext) -> [TaskItem] {
        do {
            let request = dailyTasksFetch()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskItem.order, ascending: true)]
            return try context.fetch(request)
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
    }

    
    func dailyTasksFetch() -> NSFetchRequest<TaskItem> {
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = sortOrder()
        request.predicate = predicate()
        return request
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let creationDateSort = NSSortDescriptor(keyPath: \TaskItem.created, ascending: false)
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        let orderSort = NSSortDescriptor(keyPath: \TaskItem.order, ascending: true)
        
        return [creationDateSort, completedDateSort, timeSort, dueDateSort, orderSort]
    }
    
    private func predicate() -> NSPredicate {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
        return NSPredicate(format: "dueDate >= %@ AND dueDate < %@", start as NSDate, end! as NSDate)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshTaskItems(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
