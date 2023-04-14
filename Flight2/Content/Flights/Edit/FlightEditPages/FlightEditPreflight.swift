//
// File: FlightEditPreflight.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI
import UtilityViews

struct FlightEditPreflight: View {
    
    @ObservedObject var editViewModel: FlightEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditSectionHeader("Pre-flight Checks")
   
            Toggle(isOn: $editViewModel.checksPerformed,
                   label: {Text("Checks Performed")})
            
            FlightIssuesListView(issues: $editViewModel.preflightIssues, editable: true, viewTitle: "Pre-flight Issues")
                .frame(height: 200)
            
            Toggle(isOn: $editViewModel.issuesResolved,
                   label: { Text("All issues resolved") } )
            
            Spacer()
        }
    }
}

struct FlightEditPreflight_Previews: PreviewProvider {
    static var previews: some View {
        FlightEditPreflight(editViewModel: FlightEditViewModel(flightID: nil))
    }
}
