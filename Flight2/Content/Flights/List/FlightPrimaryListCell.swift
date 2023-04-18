//
// File: FlightListCellView.swift
// Package: Flight2
// Created by: Steven Barnett on 11/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct FlightPrimaryListCell: View {
    
    @ObservedObject var flight: Flight
    @State var groupedBy: GroupFlightsBy
    
    var body: some View {
        HStack {
            if groupedBy == .pilot {
                PilotListCellView(pilot: flight.viewPilot)
            } else {
                AircraftListCellView(aircraft: flight.viewAircraft)
            }
        }
    }
}

struct FlightListCell_Previews: PreviewProvider {
    static var previews: some View {
        FlightPrimaryListCell(
            flight: Flight.dummyData,
            groupedBy: .pilot
        )
    }
}
