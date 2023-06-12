//
// File: AircraftStatisticsView.swift
// Package: Flight2
// Created by: Steven Barnett on 12/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftStatisticsView: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        Section(content: {
            StatisticsView(statistics: vm.statistics)
        }, header: {
            SectionTitle("Flight Statistics")
        })
    }
}

struct AircraftStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftStatisticsView(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
