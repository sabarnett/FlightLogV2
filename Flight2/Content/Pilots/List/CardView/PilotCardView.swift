//
// File: PilotsListItemView.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 16/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PilotCardView: View {
    
    let pilot: Pilot
    var cardWidth: CGFloat
    
    var cardFrameWidth: CGFloat {
        // Note: GeometryReader may return a negative value, so we trap it here
        if cardWidth < 120 { return 120 }
        return cardWidth
    }
    
    var body: some View {
        VStack {
            VStack {
                Image(uiImage: pilot.viewProfileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)).shadow(color: .secondary, radius: 3, x: 2, y: 2)
                    .frame(width: cardFrameWidth, height: 220)
                    .padding(4)
                
                Text(pilot.displayName).font(.title)
                Text(pilot.viewCAARegistration).font(.title2)
                
                SplitText(prompt: "Mobile", value: pilot.viewMobilePhone)
                SplitText(prompt: "Phone", value: pilot.viewAlternatePhone)
                SplitText(prompt: "Email", value: pilot.viewEmailAddress)
                
                Spacer()
            }
            .foregroundColor(pilot.pilotDeleted ? Color(.systemRed) : .primary)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.secondary)
                    .opacity(0.2)
            )
        }.padding(.bottom, 40)
    }
}

struct SplitText: View {
    
    var prompt: String
    var value: String
    
    var body: some View {
        HStack {
            Text(prompt)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }.padding(.vertical, 5)
    }
    
}

//struct PilotsListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        PilotCardView(pilot: pilotListModel(pilot: Pilot.dummyData),
//                      cardWidth: 220)
//            .previewLayout(.sizeThatFits)
//    }
//}
