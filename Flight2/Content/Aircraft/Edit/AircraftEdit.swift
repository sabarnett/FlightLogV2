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
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section("Profile Picture") {
                        HStack {
                            Spacer()
                            ImagePickerView(image: $editViewModel.aircraftImage,
                                            placeholderImage: "aircraft-placeholder")
                            Spacer()
                        }
                        .padding()
                    }
                    Section("Aircraft") {
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
                    
                    Section("Purchase") {
                        FloatingTextView("Purchased From", text: $editViewModel.purchasedFrom)
                            .autocorrectionDisabled(true)
                        
                        DateTimePickerButton(label: "Purchase Date",
                                             dateTime: $editViewModel.purchasedDate,
                                             showPicker: $showPurchaseDatePicker,
                                             showTimeComponent: false)
                        
                        .disabled(!editViewModel.hasPurchaseLocation())
                        .foregroundColor(!editViewModel.hasPurchaseLocation() ? .secondary : .primary)
                        
                        Toggle(isOn: $editViewModel.purchasedNew,
                               label: { Text("New at Purchase")})
                        .disabled(!editViewModel.hasPurchaseLocation())
                        .foregroundColor(!editViewModel.hasPurchaseLocation() ? .secondary : .primary)
                    }
                    Section("Notes") {
                        TextEdit(placeholder: "Notes", text: $editViewModel.notes)
                            .frame(minHeight: 100)
                    }
                    
                    if editViewModel.hasErrors {
                        Section("Errors") {
                            Text(editViewModel.errorDigest)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                .listStyle(.grouped)
                
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
                }.padding(.bottom, 8)
            }
            .blur(radius: showPurchaseDatePicker ? 8 : 0)
            .interactiveDismissDisabled(true)
            .overlay(alignment: .topTrailing) {
                Button(action: {
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
