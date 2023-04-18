//
// File: FlightIssueEditView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightIssueEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var issue: FlightIssueModel
    
    @State var title: String = ""
    @State var notes: String = ""
    @State var resolved: Bool = false
    
    init(issue: Binding<FlightIssueModel>) {
        self._issue = issue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            List {
                Section("") {
                    FloatingTextView("Short Description", text: $title)

                    TextEdit(placeholder: "Long Description", text: $notes)
                        .frame(minHeight: 300)
                }
                Section("") {
                    Toggle(isOn: $resolved,
                           label: { Text("Issue Resolved")})
                }
            }
            
            Spacer()
            HStack {
                Spacer()
                
                Button("Save") {
                    self.issue.title = title
                    self.issue.notes = notes
                    self.issue.resolved = resolved
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
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() },
                   label: { XDismissButton() })
        }
        .onAppear {
            self.title = issue.title
            self.notes = issue.notes
            self.resolved = issue.resolved

        }
    }
}

struct FlightIssueEditView_Previews: PreviewProvider {
    static var previews: some View {
        FlightIssueEditView(issue: .constant(FlightIssueModel(flightIssue: nil)))
    }
}
