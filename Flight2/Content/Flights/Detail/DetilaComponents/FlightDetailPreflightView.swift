//
// File: FlightDetailPreflightView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightDetailPreflightView: View {
    @State var vm: FlightDetailViewModel
    
    var body: some View {
        Section(content: {
            VStack(alignment: .leading) {
                CheckBoxView(caption: "Checks Performed", checked: vm.preflightChecksPerformed)
                FlightIssuesListView(issues: $vm.preflightIssues,
                                     editable: false,
                                     viewTitle: "Preflight Issues")
                .frame(minHeight: 200)
                CheckBoxView(caption: "Issues Resolved", checked: vm.preflightIssuesResolved)
            }
        }, header: {
            SectionTitle("Pre-flight Checks")
        })
    }
}
