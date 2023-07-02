//
// File: AircraftEditDetails.swift
// Package: Flight2
// Created by: Steven Barnett on 02/07/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI
import UtilityViews

struct AircraftEditDetails: View {

    @ObservedObject var editViewModel: AircraftEditViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(showsIndicators: false) {
                EditSectionHeader("Details")
            
                Text("Please give us a brief description of the aircraft and it's history.")
                TextEdit(placeholder: "Details", text: $editViewModel.details)
                    .frame(minHeight: 400)
            }
            Spacer()
        }
    }
}
