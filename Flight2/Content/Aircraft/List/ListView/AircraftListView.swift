//
// File: AircraftListView.swift
// Package: Flight2
// Created by: Steven Barnett on 23/05/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftListView: View {

    @ObservedObject var vm: AircraftListViewModel

    var body: some View {
        List(vm.aircraftList, id: \.objectID, selection: $vm.selectedAircraftID) {
            aircraft in
                NavigationLink(value: aircraft.objectID) {
                    AircraftListCellView(aircraft: aircraft)
                }
            }
        .listStyle(.plain)
    }
}

struct AircraftListView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftListView(vm: AircraftListViewModel())
    }
}
