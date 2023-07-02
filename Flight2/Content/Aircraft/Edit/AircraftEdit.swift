//
// File: AircraftEdit.swift
// Package: Flight2
// Created by: Steven Barnett on 10/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftEdit: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var editViewModel: AircraftEditViewModel
    @State private var isEditingAddress: Bool = false
    @State private var showPurchaseDatePicker: Bool = false

    @State private var wizardSteps: [String] = ["Aircraft", "Details", "Purchase", "Maintenance", "Notes"]
    @State private var selectedStep: String = "Aircraft"
    
    var body: some View {
        ZStack {
            VStack {
                SegmentedView(segments: wizardSteps,
                              showBackground: false,
                              segmentStyle: .underline,
                              selected: $selectedStep)
                
                TabView(selection: $selectedStep) {
                    AircraftEditAircraft(editViewModel: editViewModel)
                        .tag("Aircraft")
                        .padding(.horizontal, 20)
                    
                    AircraftEditDetails(editViewModel: editViewModel)
                        .tag("Details")
                        .padding(.horizontal, 20)
                    
                    AircraftEditPurchase(editViewModel: editViewModel,
                                         showPurchaseDatePicker: $showPurchaseDatePicker)
                        .tag("Purchase")
                        .padding(.horizontal, 20)

                    AircraftEditMaintenance(editViewModel: editViewModel)
                        .tag("Maintenance")
                        .padding(.horizontal, 20)
                    
                    AircraftEditNotes(editViewModel: editViewModel)
                        .tag("Notes")
                        .padding(.horizontal, 20)
                }
                
                if editViewModel.hasErrors {
                    Section("Errors") {
                        Text(editViewModel.errorDigest)
                            .foregroundColor(Color(.systemRed))
                    }
                }
                
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
                        editViewModel.cancel()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.systemRed))
                }.padding(.bottom, 8)
            }
            .blur(radius: showPurchaseDatePicker ? 8 : 0)
            .interactiveDismissDisabled(true)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    editViewModel.cancel()
                    dismiss()
                }, label: {
                    XDismissButton()
                })
            }
            
            if showPurchaseDatePicker {
                DateTimePopup(selectedDate: $editViewModel.purchasedDate,
                              showPopup: $showPurchaseDatePicker,
                              maxDate: Date.now,
                              showTimePicker: false)
                .transition(.scale)
            }
        }
    }
}

struct AircraftEdit_Previews: PreviewProvider {
    static var previews: some View {
        AircraftEdit(editViewModel: AircraftEditViewModel(aircraftID: nil))
    }
}
