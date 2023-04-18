//
// File: FlightIssue+Extensions.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 11/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

extension FlightIssue {
    var viewTitle: String { self.title ?? "" }
    var viewNotes: String { self.notes ?? "" }
    var viewResolved: Bool { self.resolved }
}

extension FlightIssue: BaseModel {
    // TODO: Add extension items
    
    // MARK: - Dummy data for preview usage
    static var dummyData: FlightIssue {
        let issue = FlightIssue()
        issue.title = "Issue Title"
        issue.notes = "Issue descriptive note providing more detail of the problem."
        issue.resolved = false
        
        return issue
    }
}
