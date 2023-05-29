//
// File: AircraftCardView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftCardView: View {

    let aircraft: Aircraft
    let cardWidth: CGFloat
    
    var cardFrameWidth: CGFloat {
        // Note: GeometryReader may return a negative value, so we trap it here
        if cardWidth < 120 { return 120 }
        return cardWidth
    }
    
    var body: some View {
        VStack {
            VStack {
                Image(uiImage: aircraft.viewAircraftImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)).shadow(color: .secondary, radius: 3, x: 2, y: 2)
                    .frame(width: cardFrameWidth, height: 220)
                    .padding(4)
                
                Text(aircraft.viewName).font(.title)
                Text(aircraft.viewSerialNumber).font(.title2)
                
                SplitText(prompt: "Mfr", value: aircraft.viewManufacturer)
                SplitText(prompt: "Model", value: aircraft.viewModel)
                
                if aircraft.hasPurchaseData {
                    SplitText(prompt: "Purchased",
                              value: aircraft.formattedPurchaseDate)
                    SplitText(prompt: "From", value: aircraft.viewPurchasedFrom)
                    SplitText(prompt: "New?", value: aircraft.newAtPurchase ? "Yes" : "No")
                } else {
                    SplitText(prompt: "Purchased", value: "unknown")
                    SplitText(prompt: "From", value: "")
                    SplitText(prompt: "New?", value: "")
                }
                
                Spacer()
            }
            .foregroundColor(aircraft.aircraftDeleted ? Color(.systemRed) : .primary)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.secondary)
                    .opacity(0.2)
            )
        }.padding(.bottom, 40)
    }
}

struct AircraftCardView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftCardView(aircraft: Aircraft.dummyData, cardWidth: 220)
            .previewLayout(.sizeThatFits)
    }
}
