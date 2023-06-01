//
// File: AircraftPurchaseDetail.swift
// Package: Flight2
// Created by: Steven Barnett on 01/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftPurchaseDetail: View {

    @ObservedObject var vm: AircraftDetailViewModel

    var body: some View {
        if vm.aircraft.hasPurchaseData {
            Section(content: {
                DetailLine(key: "From", value: vm.aircraft.viewPurchasedFrom)
                DetailLine(key: "On", value: vm.aircraft.formattedPurchaseDate)
                DetailLine(key: "New?", value: vm.aircraft.viewNewAtPurchase)
            }, header: {
                SectionTitle("Purchase Info")
            })
        }
    }
}

struct AircraftPurchaseDetail_Previews: PreviewProvider {
    static var previews: some View {
        AircraftPurchaseDetail(vm: AircraftDetailViewModel(aircraft: Aircraft.dummyData))
    }
}
