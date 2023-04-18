//
// File: FlightEditLocation.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightEditLocation: View {
    
    @ObservedObject var editViewModel: FlightEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditSectionHeader("Flight Location")
            
            ScrollView(showsIndicators: false) {
                FloatingTextView("Location", text: $editViewModel.location)
                
                TextEdit(placeholder: "Weather Conditions", text: $editViewModel.weatherConditions)
                    .frame(minHeight: 200)
                
                TextEdit(placeholder: "Site Conditions", text: $editViewModel.siteConditions)
                    .frame(minHeight: 200)
                
                Spacer()
            }
        }
    }
}

struct FlightEditLocation_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditLocation(editViewModel: FlightEditViewModel(flightID: nil))
    }
}
