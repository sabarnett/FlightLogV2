//
// File: FlightIncidentCell.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 11/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct FlightIssueCell: View {
    
    var issue: FlightIssueModel
    
    var body: some View {
        HStack {
            Image(systemName: issue.resolved ? "checkmark" : "xmark")
            Text(issue.title)
                .font(.body)
                .strikethrough(issue.isDeleted)
            Spacer()
        }.foregroundColor(issueTextColor)
    }
    
    var issueTextColor: Color {
        if issue.isDeleted {
            return Color(.placeholderText)
        }
        return issue.resolved ? Color(.systemGreen) : Color(.systemRed)
    }
}

struct FlightIncidentCell_Previews: PreviewProvider {
    static var previews: some View {
        FlightIssueCell(issue: FlightIssueModel(flightIssue: FlightIssue.dummyData))
    }
}
