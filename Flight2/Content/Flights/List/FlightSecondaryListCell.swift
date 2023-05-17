//
// File: FlightSecondaryListView.swift
// Package: Flight2
// Created by: Steven Barnett on 18/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct FlightSecondaryListCell: View {
    
    @ObservedObject var flight: Flight
    @State var groupedBy: GroupFlightsBy = .pilot
    
    var body: some View {
        HStack {
            if let image = (groupedBy == .pilot)
                ? flight.viewAircraft.aircraftImage?.image
                : flight.viewPilot.profileImage?.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.secondary.opacity(0.2))
                    Image(systemName: "photo")
                        .scaleEffect(1.3)
                        .foregroundColor(.secondary.opacity(0.5))
                }
                .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading) {
                Text(flight.viewTitle).font(.body)
                Label("\(flight.viewTakeoffDate)", systemImage: "airplane.departure").font(.caption)
                Label("\(flight.viewLandingDate)", systemImage: "airplane.arrival").font(.caption)
            }.foregroundColor(flight.isDeleted
                              ? Color(.systemRed)
                              : .primary)
        }
    }
}

struct FlightSecondaryListCell_Previews: PreviewProvider {
    static var previews: some View {
        FlightSecondaryListCell(
            flight: Flight.dummyData
        )
    }
}
