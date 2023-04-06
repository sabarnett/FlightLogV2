//
// File: PilotListCellView.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct PilotListCellView: View {
    
    @State var pilot: pilotListModel
    
    var body: some View {
        HStack {
            Image(uiImage: pilot.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            VStack(alignment: .leading) {
                Text("\(pilot.firstName) \(pilot.lastName)").font(.title3)
                Text(pilot.caaRegistration).font(.caption)
                Text(pilot.mobilePhone).font(.caption)
            }.foregroundColor(pilot.isDeleted ? Color(.systemRed) : .primary)
        }
    }
}

struct PilotListCellView_Previews: PreviewProvider {
    static var previews: some View {
        PilotListCellView(pilot: pilotListModel(pilot: Pilot.dummyData))
            .previewLayout(.sizeThatFits)
    }
}
