//
// File: AircraftEditNotes.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftEditNotes: View {

    @ObservedObject var editViewModel: AircraftEditViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(showsIndicators: false) {
                EditSectionHeader("Notes")
            
                TextEdit(placeholder: "Notes", text: $editViewModel.notes)
                    .frame(minHeight: 400)
            }
            Spacer()
        }
    }
}
