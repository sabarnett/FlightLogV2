//
// File: MaintenanceItemEditView.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct MaintenanceItemEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var item: AircraftMaintenanceModel
    
    @State var title: String = ""
    @State var action: String = ""
    @State var actionDate: Date?
    
    @State private var showDatePicker: Bool = false
    
    init(item: Binding<AircraftMaintenanceModel>) {
        self._item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            List {
                Section("") {
                    DateTimePickerButton(label: "Action Date",
                                         dateTime: $actionDate,
                                         showPicker: $showDatePicker)
                }
                Section("") {
                    FloatingTextView("Action", text: $title)

                    TextEdit(placeholder: "Action Description", text: $action)
                         .frame(minHeight: 300)
                 }
             }
             
             Spacer()
            
             HStack {
                 Spacer()
                 
                 Button("Save") {
                     self.item.title = title
                     self.item.action = action
                     self.item.actionDate = actionDate
                     dismiss()
                 }
                 .buttonStyle(.borderedProminent)
                 .tint(Color(.systemGreen))
                 .disabled(title.isEmpty)
                 
                 Button("Cancel") {
                     dismiss()
                 }
                 .buttonStyle(.borderedProminent)
                 .tint(Color(.systemRed))
                 
                 Spacer()
             }
             .padding()
            
            if showDatePicker {
                DateTimePopup(selectedDate: $actionDate,
                              showPopup: $showDatePicker)
                .transition(.scale)
            }
         }
         .overlay(alignment: .topTrailing) {
             Button(action: { dismiss() },
                    label: { XDismissButton() })
         }
         .onAppear {
             self.title = item.title
             self.action = item.action
             self.actionDate = item.actionDate

         }

    }
}
