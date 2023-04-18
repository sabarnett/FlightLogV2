//
// File: FlightDetailActivityView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct FlightDetailActivityView: View {
    
    @State var vm: FlightDetailViewModel
    
    var body: some View {
        Section(content: {
            VStack(alignment: .leading) {
                Text(vm.activity).font(.body)
            }
        }, header: {
            SectionTitle("Flight Activity")
        })
    }
}
