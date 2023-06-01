//
// File: AircraftDetailNotes.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftDetailNotes: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        Section(content: {
            HStack {
                Text(vm.aircraft.viewNotes)
                    .lineLimit(10)
                Spacer()
            }.padding(.horizontal, 16)
        }, header: {
            SectionTitle("Notes")
        })
    }
}

struct AircraftDetailNotes_Previews: PreviewProvider {
    static var previews: some View {
        AircraftDetailNotes(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
