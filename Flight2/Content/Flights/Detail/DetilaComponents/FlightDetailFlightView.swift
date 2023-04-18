//
// File: FlightDetailFlightView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI
import UtilityViews

struct FlightDetailFlightView: View {
    
    @State var vm: FlightDetailViewModel
    
    var body: some View {
        Section(content: {
            VStack(alignment: .leading) {
                FlightDuration(vm: vm)
                    .padding(.top, 3)
                
                FlightIssuesListView(issues: $vm.flightIssues,
                                     editable: false,
                                     viewTitle: "Flight Issues")
                    .frame(minHeight: 200)

                SectionSubtitle("Flight Review")
                Text(vm.details)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }, header: {
            SectionTitle("Flight")
        })
    }
}

struct FlightDuration: View {
    
    @ObservedObject var vm: FlightDetailViewModel
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "airplane.departure")
                Text(vm.takeoffDate).font(.caption)
                Text(vm.takeoffTime).font(.caption)
            }
            
            Spacer()
            VStack {
                Image(systemName: "airplane")
                Text(vm.flightDuration).font(.caption)
                Text("")
            }
            
            Spacer()
            VStack {
                Image(systemName: "airplane.arrival")
                Text(vm.landingDate).font(.caption)
                Text(vm.landingTime).font(.caption)
            }
        }
    }
}

