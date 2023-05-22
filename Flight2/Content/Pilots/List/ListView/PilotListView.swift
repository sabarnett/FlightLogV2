//
// File: PilotListView.swift
// Package: Flight2
// Created by: Steven Barnett on 22/05/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PilotListView: View {

    @ObservedObject var vm: PilotsListViewModel

    var body: some View {
        List(vm.pilotList, id: \.objectID, selection: $vm.selectedPilotID) { pilot in
            NavigationLink(value: pilot.objectID) {
                PilotListCellView(pilot: pilot)
            }
        }
        .listStyle(.plain)
    }
}
