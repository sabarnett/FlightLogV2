//
// File: AircraftGridCellView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct AircraftGridCellView: View {
    
    let aircraft: Aircraft
    
    var body: some View {
        VStack {
            Image(uiImage: aircraft.viewAircraftImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text(aircraft.viewName).font(.caption)
            Text(aircraft.viewSerialNumber).font(.title3)
        }.foregroundColor(aircraft.aircraftDeleted ? Color(.systemRed) : .primary)
    }
}

struct AircraftGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftGridCellView(aircraft: Aircraft.dummyData)
            .previewLayout(.sizeThatFits)
    }
}
