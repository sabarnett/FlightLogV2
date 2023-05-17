//
// File: AircraftListCellView.swift
// Package: Flight2
// Created by: Steven Barnett on 10/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftListCellView: View {
    
    @ObservedObject var aircraft: Aircraft
    
    var body: some View {
        HStack {
            Image(uiImage: aircraft.viewAircraftImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                Text(aircraft.viewName)
                    .font(.title3)
                    .foregroundColor(.primary)
                Text(aircraft.viewManufacturer).font(.caption)
                Text(aircraft.viewModel).font(.caption)
            }.foregroundColor(aircraft.aircraftDeleted ? Color(.systemRed) : .primaryText)
        }
    }
}

struct AircraftListCellView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftListCellView(aircraft: Aircraft.dummyData)
            .previewLayout(.sizeThatFits)
    }
}
