//
// File: AircraftEditAircraft.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftEditAircraft: View {

    @ObservedObject var editViewModel: AircraftEditViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(showsIndicators: false) {
                EditSectionHeader("Profile Picture")
                HStack {
                    ImagePickerView(image: $editViewModel.aircraftImage,
                                    placeholderImage: "aircraft-placeholder")
                    Spacer()
                }
                    .padding()
                
                EditSectionHeader("Aircraft")
                
                FloatingTextView("Name", text: $editViewModel.name)
                    .autocorrectionDisabled(true)
                FloatingTextView("Manufacturer", text: $editViewModel.manufacturer)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                FloatingTextView("Model", text: $editViewModel.model)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                FloatingTextView("Serial Number", text: $editViewModel.serialNumber)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            }
        }
    }
}
