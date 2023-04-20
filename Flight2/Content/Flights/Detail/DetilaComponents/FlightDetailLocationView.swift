//
// File: FlightDetailLocationView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct FlightDetailLocationView: View {
    
    @ObservedObject var vm: FlightDetailViewModel
    
    var body: some View {
        Section(content: {
            VStack(alignment: .leading) {
                SectionSubtitle("Location")
                Text(vm.location).padding(.bottom, 8)
                    .fixedSize(horizontal: false, vertical: true)

                SectionSubtitle("Weather Conditions")
                Text(vm.weatherConditions).padding(.bottom, 8)
                    .fixedSize(horizontal: false, vertical: true)
                    
                SectionSubtitle("Site Conditions")
                Text(vm.siteConditions).padding(.bottom, 8)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }, header: {
            SectionTitle("Location")
        })
    }
}
