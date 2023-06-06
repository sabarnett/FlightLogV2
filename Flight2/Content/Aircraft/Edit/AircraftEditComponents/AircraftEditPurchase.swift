//
// File: AircraftPurchase.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftEditPurchase: View {

    @ObservedObject var editViewModel: AircraftEditViewModel
    @Binding var showPurchaseDatePicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(showsIndicators: false) {
                EditSectionHeader("Purchase")
                
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
            Spacer()
        }
    }
}
