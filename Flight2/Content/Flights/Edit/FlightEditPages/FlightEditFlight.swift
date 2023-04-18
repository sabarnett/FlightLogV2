//
// File: FlightEditFlight.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightEditFlight: View {
    
    @ObservedObject var editViewModel: FlightEditViewModel
    @Binding var showTakeoffPicker: Bool
    @Binding var showLandingPicker: Bool
    @State private var confirmFlightDuration: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditSectionHeader("Flight Details")
            
            ScrollView(showsIndicators: false) {
                DateTimePickerButton(label: "Take-off",
                                     dateTime: $editViewModel.takeOff,
                                     showPicker: $showTakeoffPicker)
                
                DateTimePickerButton(label: "Landing",
                                     dateTime: $editViewModel.landing,
                                     showPicker: $showLandingPicker)
                .disabled(!editViewModel.hasTakeoffDate)
                .foregroundColor(!editViewModel.hasTakeoffDate
                                 ? Color(.placeholderText)
                                 : .primary)
                KeyValueView(key: "Duration", value: editViewModel.duration)
                
                TextEdit(placeholder: "Flight Review", text: $editViewModel.flightDetails)
                    .frame(height: 200)
                
                FlightIssuesListView(issues: $editViewModel.flightIssues, editable: true, viewTitle: "Flight Issues")
                    .frame(height: 200)
                
                Spacer()
            }
        }
        .onChange(of: editViewModel.landing) { value in
            if !editViewModel.validateDuration() {
                // Flight duration is over 60 minutes - confirm with the user
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // or even shorter
                    confirmFlightDuration.toggle()
                }
            }
        }
        .alert(isPresented: $confirmFlightDuration) {
            Alert(
                title: Text("Use this landing date?"),
                message: Text("The flight duration is over 60 minutes. Is this Ok?"),
                primaryButton: .destructive(Text("Yes"),
                                            action: {}),
                secondaryButton: .cancel(Text("No"),
                                         action: {editViewModel.landing = nil})
            )
        }
    }
}

struct FlightEditFlight_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditFlight(editViewModel: FlightEditViewModel(flightID: nil),
                         showTakeoffPicker: .constant(true),
                         showLandingPicker: .constant(true))
    }
}
