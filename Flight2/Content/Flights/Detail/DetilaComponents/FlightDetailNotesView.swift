//
// File: FlightDetailNotesView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct FlightDetailNotesView: View {
    @State var vm: FlightDetailViewModel
    
    var body: some View {
        Section("Notes") {
            VStack(alignment: .leading) {
                Text(vm.notes)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

