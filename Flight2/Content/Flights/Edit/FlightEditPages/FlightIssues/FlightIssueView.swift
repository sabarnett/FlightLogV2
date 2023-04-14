//
// File: FlightIssueView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 18/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI
import UtilityViews

struct FlightIssueView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var issue: FlightIssueModel
    
    var body: some View {
        VStack {
            List {
                Section("Short Description") {
                    Text(issue.title)
                }
                
                Section("Notes") {
                    Text(issue.notes)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 350, alignment: .topLeading)
                }
                
                Section("Resolved") {
                    Text(issue.resolved
                         ? "This issue has been resolved"
                         : "This issue is waiting to be fixed")
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button { dismiss() } label: { XDismissButton() }
        }
    }
}

struct FlightIssueView_Previews: PreviewProvider {
    static var previews: some View {
        FlightIssueView(issue: FlightIssueModel(flightIssue: nil))
    }
}
