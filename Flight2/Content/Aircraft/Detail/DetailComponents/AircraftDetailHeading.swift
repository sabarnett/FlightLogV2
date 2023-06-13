//
// File: AircraftDetailHeading.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftDetailHeading: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            HStack(alignment: .top) {
                Image(uiImage: vm.aircraft.viewAircraftImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(2)
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(vm.aircraft.viewName) by \(vm.aircraft.viewManufacturer)")
                        .font(.title)
                        .foregroundColor(Color.heading)
                    Text(vm.aircraft.viewModel)
                        .font(.title2)
                        .foregroundColor(.primaryText)

                    Text("s/n \(vm.aircraft.viewSerialNumber)")
                        .font(.title2)
                        .foregroundColor(.primaryText)

                }.foregroundColor(.primaryText)
                Spacer()
            }.frame(height: 210)
                .padding(20)
        } else {
            Image(uiImage: vm.aircraft.viewAircraftImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(2)
        }
    }
}

struct AircraftDetailHeading_Previews: PreviewProvider {
    static var previews: some View {
        AircraftDetailHeading(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
