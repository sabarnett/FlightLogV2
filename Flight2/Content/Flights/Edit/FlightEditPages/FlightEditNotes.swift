//
// File: FlightEditNotes.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI
import UtilityViews

struct FlightEditNotes: View {

    @ObservedObject var editViewModel: FlightEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditSectionHeader("Notes")
   
            TextEdit(placeholder: "Notes", text: $editViewModel.notes)
                .frame(minHeight: 300)
            
            Spacer()
        }
    }
}

struct FlightEditNotes_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditNotes(editViewModel: FlightEditViewModel(flightID: nil))
    }
}
