//
// File: AircraftDetailsView.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftDetails: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        Section(content: {
            DetailLine(key: "Details", value: vm.aircraft.viewdetails)
                .foregroundColor(.primaryText)

        }, header: {
            SectionTitle("Description")
        })
    }
}

struct AircraftDetails_Previews: PreviewProvider {
    static var previews: some View {
        AircraftDetails(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
