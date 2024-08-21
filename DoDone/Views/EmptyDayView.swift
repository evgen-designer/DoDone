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
                .frame(width: 170)
                .padding()

            VStack(spacing: 15) {
                Text("Nothing on your plate today")
//                    .font(.title2)
//                    .fontWeight(.bold)
                    .font(.system(size: 18, weight: .bold))

                Text("Time to relax!")
                    .font(.system(size: 15))
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
