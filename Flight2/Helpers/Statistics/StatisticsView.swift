//
// File: StatisticsView.swift
// Package: Flight2
// Created by: Steven Barnett on 12/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {

    var statistics: StatisticsSummary

    var body: some View {
        VStack(alignment: .leading) {
            Text("Total Flights: \(statistics.flightCount)")
                .font(.body)
            Text("Total Flight Time: \(statistics.formattedFlightDuration) minutes")
                .font(.body)
            
            List(statistics.detail, id: \.id) { item in
                StatisticsDetailLineView(item: item)
                    .listRowBackground(Color(.secondarySystemBackground))
            }.listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }.frame(minHeight: 200)
    }
}

struct StatisticsDetailLineView: View {
    
    var item: StatisticsSummaryItem
    
    var body: some View {
        HStack(alignment: .top) {
            Text(item.title)
            Spacer()
            VStack(alignment: .leading) {
                Text("Flights: \(item.count)")
                Text("Duration: \(item.formattedFlightDuration) Minutes")
            }.frame(minWidth: 120)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(statistics: StatisticsSummary())
    }
}
