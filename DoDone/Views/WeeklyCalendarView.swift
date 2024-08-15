//
//  WeeklyCalendarView.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @EnvironmentObject var dateHolder: DateHolder
    @Environment(\.managedObjectContext) private var viewContext
    let daysInWeek = 7
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(daysOfTheWeek(), id: \.self) { date in
                    DateButton(date: date, isSelected: isSelected(date), isToday: isToday(date)) {
                        selectedDate = date
                        dateHolder.date = date
                        dateHolder.refreshTaskItems(viewContext)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 {
                            moveWeek(by: 1)
                        } else if value.translation.width > 0 {
                            moveWeek(by: -1)
                        } else if value.translation.height > 0 {
                            // Implement full month view here (if necessary)
                        }
                    }
            )
        }
        .onAppear {
            selectedDate = dateHolder.date
        }
    }
    
    func daysOfTheWeek() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
        
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: dateHolder.date))!
        return (0..<daysInWeek).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    func moveWeek(by weeks: Int) {
        withAnimation {
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: selectedDate)!
            dateHolder.date = selectedDate
            dateHolder.refreshTaskItems(viewContext)
        }
    }
}

#Preview {
    WeeklyCalendarView()
        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
}
