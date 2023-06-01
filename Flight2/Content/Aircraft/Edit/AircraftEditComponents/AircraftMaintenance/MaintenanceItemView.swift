//
// File: MaintenanceItemView.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct MaintenanceItemView: View {

    @Environment(\.dismiss) private var dismiss

    var item: AircraftMaintenanceModel

    var body: some View {
        VStack {
            List {                
                Section(content: {
                    Text(item.maintenanceItem?.viewActionDate?.appDate ?? "")
                }, header: {
                    SectionTitle("Action Date")
                })

                Section(content: {
                    Text(item.title)
                }, header: {
                    SectionTitle("Action")
                })
                
                Section(content: {
                    Text(item.action)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 350, alignment: .topLeading)
                }, header: {
                    SectionTitle("Action Performed")
                })
            }.padding(.top, 20)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() },
                   label: { XDismissButton() })
        }
    }
}
