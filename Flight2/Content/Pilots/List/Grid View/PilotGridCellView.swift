//
// File: PilotGridCellView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 12/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PilotGridCellView: View {
    
    let pilot: Pilot
    
    var body: some View {
        VStack {
            Image(uiImage: pilot.viewProfileImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text(pilot.displayName).font(.title3)
            Text(pilot.viewCAARegistration).font(.caption)
        }.foregroundColor(pilot.pilotDeleted ? Color(.systemRed) : .primary)
    }
}

struct PilotGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        PilotGridCellView(pilot: Pilot.dummyData)
            .previewLayout(.sizeThatFits)
    }
}
