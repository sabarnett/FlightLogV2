//
// File: PilotListCellView.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct PilotListCellView: View {
    
    @ObservedObject var pilot: Pilot
    
    var body: some View {
        HStack {
            Image(uiImage: pilot.viewProfileImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            VStack(alignment: .leading) {
                Text("\(pilot.viewFirstName) \(pilot.viewLastName)").font(.title3)
                Text(pilot.viewCAARegistration).font(.caption)
                Text(pilot.viewMobilePhone).font(.caption)
            }.foregroundColor(pilot.pilotDeleted ? Color(.systemRed) : .primary)
        }
    }
}

struct PilotListCellView_Previews: PreviewProvider {
    static var previews: some View {
        PilotListCellView(pilot: Pilot.dummyData)
            .previewLayout(.sizeThatFits)
    }
}
