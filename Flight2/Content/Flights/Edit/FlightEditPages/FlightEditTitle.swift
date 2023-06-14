//
// File: FlightEditTitle.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightEditTitle: View {

    @ObservedObject var editViewModel: FlightEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditSectionHeader("Activity Description")

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    FloatingTextView("Title", text: $editViewModel.title)
                    
                    TextEdit(placeholder: "Expected Activity", text: $editViewModel.expectedActivity)
                        .frame(minHeight: 200)
                }
                .disabled(editViewModel.isLocked)

                Spacer()
            }
        }
    }
}

struct FlightEditTitle_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditTitle(editViewModel: FlightEditViewModel(flightID: nil))
    }
}
