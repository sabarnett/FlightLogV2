//
// File: AircraftEditMaintenance.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftEditMaintenance: View {

    @ObservedObject var editViewModel: AircraftEditViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(showsIndicators: false) {
                EditSectionHeader("Maintenance")
                
                MaintenanceListView(items: $editViewModel.maintenanceItems,
                                    editable: true)
            }
            Spacer()
        }
    }
}
