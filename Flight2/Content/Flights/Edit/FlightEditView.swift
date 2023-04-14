//
// File: FlightEditView.swift
// Package: Flight2
// Created by: Steven Barnett on 14/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
     
import SwiftUI
import UtilityViews

struct FlightEdit: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var editViewModel: FlightEditViewModel
    
    @State private var showPilotPicker: Bool = false
    @State private var showAircraftPicker: Bool = false
    @State private var showTakeoffPicker: Bool = false
    @State private var showLandingPicker: Bool = false
    @State private var confirmFlightDuration: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                TabView {
                    FlightEditTitle(editViewModel: editViewModel)

                    FlightEditParticipants(editViewModel: editViewModel,
                                           showPilotPicker: $showPilotPicker,
                                           showAircraftPicker: $showAircraftPicker)

                    FlightEditLocation(editViewModel: editViewModel)

                    FlightEditPreflight(editViewModel: editViewModel)

                    FlightEditFlight(editViewModel: editViewModel,
                                     showTakeoffPicker: $showTakeoffPicker,
                                     showLandingPicker: $showLandingPicker)

                    FlightEditNotes(editViewModel: editViewModel)

                }.tabViewStyle(.page)
                    .padding(.top, 30)
                
                Spacer()
                HStack {
                    Button("Save") {
                        editViewModel.save()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.systemGreen))
                    .disabled(!editViewModel.canSave())
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.systemRed))
                }
                .padding()
            }
            .padding()
            .blur(radius: showingPicker() ? 5 : 0)
            .interactiveDismissDisabled(true)
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    XDismissButton()
                }
            }
            
            if showTakeoffPicker {
                DateTimePopup(selectedDate: $editViewModel.takeOff,
                              showPopup: $showTakeoffPicker)
                .transition(.scale)
            }
            
            if showLandingPicker {
                DateTimePopup(selectedDate: $editViewModel.landing,
                              showPopup: $showLandingPicker,
                              minDate: editViewModel.takeOff)
                .transition(.scale)
            }
            
            if showPilotPicker {
                PickerPopup(pickerOptions: editViewModel.pilotList,
                            prompt: "Select a pilot from the list",
                            selectedOption: $editViewModel.selectedPilot,
                            showPopup: $showPilotPicker)
                .transition(.scale)
            }
            if showAircraftPicker {
                PickerPopup(pickerOptions: editViewModel.aircraftList,
                            prompt: "Select an aircraft from the list",
                            selectedOption: $editViewModel.selectedAircraft,
                            showPopup: $showAircraftPicker)
                .transition(.scale)
            }
        }
    }
    
    func showingPicker() -> Bool {
        return showTakeoffPicker
         || showLandingPicker
         || showPilotPicker
         || showAircraftPicker
    }
}

struct EditSectionHeader: View {
    
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

struct FlightEdit_Previews: PreviewProvider {
    static var previews: some View {
        FlightEdit(editViewModel: FlightEditViewModel(flightID: nil))
    }
}
