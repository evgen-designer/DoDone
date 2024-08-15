//
//  DateButton.swift
//  DoDone
//
//  Created by Mac on 15/08/2024.
//

import SwiftUI

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(date, format: .dateTime.weekday(.abbreviated))
                    .font(.caption)
                Text(date, format: .dateTime.day())
                    .font(.title3.bold())
            }
            .padding(8)
            .background(backgroundColor)
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if isToday {
            return .gray.opacity(0.3)
        } else {
            return .clear
        }
    }
}

#Preview {
    DateButton(date: Date(), isSelected: true, isToday: true, action: {})
}
