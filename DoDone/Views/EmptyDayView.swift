//
//  EmptyDayView.swift
//  DoDone
//
//  Created by Mac on 19/08/2024.
//

import SwiftUI

struct EmptyDayView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Image("empty-day")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding()

            VStack(spacing: 15) {
                
                Text("Nothing on your plate today")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Time to relax!")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .padding(.top)
    }
}

#Preview {
    EmptyDayView()
        .preferredColorScheme(.dark)
}
