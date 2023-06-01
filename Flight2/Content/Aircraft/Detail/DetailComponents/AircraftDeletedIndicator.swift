//
// File: AircraftDeletedIndicator.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftDeletedIndicator: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        if vm.aircraft.aircraftDeleted {
            HStack {
                Spacer()
                Text("This aircraft has been deleted")
                    .padding(.vertical, 2)
                Spacer()
            }.background(Color(.systemRed))
                .padding(.vertical, 2)
        }
    }
}

struct AircraftDeletedIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AircraftDeletedIndicator(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
