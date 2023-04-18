//
// File: FlightEditParticipants.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI
import UtilityViews

struct FlightEditParticipants: View {
    
    @ObservedObject var editViewModel: FlightEditViewModel
    
    @Binding var showPilotPicker: Bool
    @Binding var showAircraftPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditSectionHeader("Pilot/Aircraft")
   
            ScrollView(showsIndicators: false) {
                PickerPopupButton(selectedItem: editViewModel.currentPilot,
                                  showPicker: $showPilotPicker)
                PickerPopupButton(selectedItem: editViewModel.currentAircraft,
                                  showPicker: $showAircraftPicker)
                
                Spacer()
            }
        }
    }
}

struct FlightEditParticipants_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditParticipants(editViewModel: FlightEditViewModel(flightID: nil),
                               showPilotPicker: .constant(true),
                               showAircraftPicker: .constant(true))
    }
}
