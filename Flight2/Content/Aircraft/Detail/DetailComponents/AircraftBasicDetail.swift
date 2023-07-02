//
// File: AircraftBasicDetail.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftBasicDetail: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        Section(content: {
            DetailLine(key: "Name", value: vm.aircraft.viewName)
                .foregroundColor(.primaryText)

            DetailLine(key: "Manufacturer", value: vm.aircraft.viewManufacturer)
                .foregroundColor(.primaryText)

            DetailLine(key: "Model", value: vm.aircraft.viewModel)
                .foregroundColor(.primaryText)

            DetailLine(key: "Serial Number", value: vm.aircraft.viewSerialNumber)
                .foregroundColor(.primaryText)
            
        }, header: {
            SectionTitle("Aircraft")
        })
    }
}

struct AircraftBasicDetail_Previews: PreviewProvider {
    static var previews: some View {
        AircraftBasicDetail(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
