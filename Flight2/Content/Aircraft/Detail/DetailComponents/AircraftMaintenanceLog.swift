//
// File: AircraftMaintenanceLog.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftMaintenanceLog: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        Section(content: {
            List(vm.aircraft.maintenanceItems, id: \.self) { item in
                AircraftMaintenanceLogCell(maint: item)
                    .listRowBackground(Color(.secondarySystemBackground))
            }
            .listStyle(.plain)
            .frame(minHeight: 150)
        }, header: {
            SectionTitle("Maintenance Log")
        })
    }
}

struct AircraftMaintenanceLogCell: View {

    @ObservedObject var maint: AircraftMaintenance

    var body: some View {
        HStack(alignment: .top) {
            Text(maint.viewDate)
                .font(.body)
                .frame(minWidth: 60)
            VStack(alignment: .leading) {
                Text(maint.viewTitle)
                    .font(.body)
                Text(maint.viewAction)
                    .font(.caption)
            }
        }
    }
}

struct AircraftMaintenanceLog_Previews: PreviewProvider {
    static var previews: some View {
        AircraftMaintenanceLog(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
