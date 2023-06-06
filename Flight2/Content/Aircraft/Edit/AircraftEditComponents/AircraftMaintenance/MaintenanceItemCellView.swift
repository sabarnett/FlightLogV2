//
// File: MaintenanceItemCellView.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

enum maintenanceEditAction {
    case view
    case edit
    case delete
}

struct MaintenanceItemCellView: View {

    var item: AircraftMaintenanceModel
    var editable: Bool = false
    var onEditAction: (_: maintenanceEditAction, _: AircraftMaintenanceModel) -> Void
    
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                Text(item.actionDate?.appDate ?? "")
                    .font(.body)
                    .frame(minWidth: 60)
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.body)
                    Text(item.action)
                        .font(.caption)
                }
            }
            .onTapGesture {
                onEditAction(.view, item)
            }
            Spacer()
            
            HStack {
                if editable && !item.isDeleted {
                    Button( action: {
                        onEditAction(.edit, item)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .scaleEffect(1.2)
                    })
                    .buttonStyle(.plain)
                    .tint(Color(.systemBlue))
                }
                
                if editable {
                    Button(action: {
                        onEditAction(.delete, item)
                    }, label: {
                        Image(systemName: item.isDeleted
                              ? "trash.slash"
                              : "trash")
                        .scaleEffect(1.2)
                    })
                    .buttonStyle(.plain)
                    .tint(Color(.systemRed))
                }
            }
        }.foregroundColor(itemTextColor)
    }
    
    var itemTextColor: Color {
        if item.isDeleted {
            return Color(.placeholderText)
        }
        return .primary
    }
}
