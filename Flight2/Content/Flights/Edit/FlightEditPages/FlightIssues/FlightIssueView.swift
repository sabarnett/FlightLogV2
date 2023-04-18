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
                Section(content: {
                    Text(issue.title)
                }, header: {
                    SectionTitle("Short Description")
                })
                
                Section(content: {
                    Text(issue.notes)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 350, alignment: .topLeading)
                }, header: {
                    SectionTitle("Notes")
                })
                
                Section(content: {
                    Text(issue.resolved
                         ? "This issue has been resolved"
                         : "This issue is waiting to be fixed")
                }, header: {
                    SectionTitle("Resolved")
                })
            }.padding(.top, 20)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() },
                   label: { XDismissButton() })
        }
    }
}

struct FlightIssueView_Previews: PreviewProvider {
    static var previews: some View {
        FlightIssueView(issue: FlightIssueModel(flightIssue: nil))
    }
}
