//
// File: FlightIncidentCell.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 11/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

enum flightIssueEditAction {
    case view
    case edit
    case delete
    case resolve
}

struct FlightIssueCell: View {
    
    var issue: FlightIssueModel
    var editable: Bool = false
    var onEditAction: (_: flightIssueEditAction, _: FlightIssueModel) -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: issue.resolved ? "checkmark" : "xmark")
                Text(issue.title)
                    .font(.body)
                    .strikethrough(issue.isDeleted)
            }
            .onTapGesture {
                onEditAction(.view, issue)
            }
            Spacer()
            // Edit actions here...
            HStack {
                if editable && !issue.isDeleted {
                    Button( action: {
                        onEditAction(.edit, issue)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .scaleEffect(1.2)
                    })
                    .buttonStyle(.plain)
                    .tint(Color(.systemBlue))
                }
                
                if editable {
                    Button(action: {
                        onEditAction(.delete, issue)
                    }, label: {
                        Image(systemName: issue.isDeleted
                              ? "trash.slash"
                              : "trash")
                        .scaleEffect(1.2)
                    })
                    .buttonStyle(.plain)
                    .tint(Color(.systemRed))
                }
                if editable && !issue.isDeleted {
                    Button(action: {
                        onEditAction(.resolve, issue)
                    }, label: {
                        Image(systemName: issue.resolved
                              ? "xmark"
                              : "checkmark")
                        .scaleEffect(1.2)
                    })
                    .buttonStyle(.plain)
                    .tint(Color(.systemGreen))
                }
            }
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
        FlightIssueCell(issue: FlightIssueModel(flightIssue: FlightIssue.dummyData),
        editable: true,
        onEditAction: { action, issue in
            
        })
    }
}
