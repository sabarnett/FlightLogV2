//
// File: MaintenanceListView.swift
// Package: Flight2
// Created by: Steven Barnett on 06/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct MaintenanceListView: View {

    @Binding var items: [AircraftMaintenanceModel]
    @State var editable: Bool = false
    @State var selectedItem: AircraftMaintenanceModel?
    @State var viewTitle: String = "Maintenance Actions"
    @State var showAdd: Bool = false
    @State var showEdit: Bool = false
    @State var showIssue: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var itemToEdit: AircraftMaintenanceModel = AircraftMaintenanceModel(maintenanceItem: nil)

    var body: some View {
        VStack {
            // Title of the list
            HStack {
                Text(viewTitle)
                    .font(.caption)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.bottom, 3)
                Spacer()
            }
            
            if items.count == 0 {
                VStack {
                    Text("No maintenance items logged")
                        .foregroundColor(Color(.placeholderText))
                    Spacer()
                }
            } else {
                VStack {
                    List(items, id: \.listId, selection: $selectedItem) { item in
                        MaintenanceItemCellView(item: item,
                                        editable: editable,
                                        onEditAction: listEditAction)
                            .listRowBackground(Color(.secondarySystemBackground))
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .frame(minHeight: 350)
                    .confirmationDialog("Are you sure?", isPresented: $showDeleteConfirmation, actions: {
                        Button("Delete maintenance item?", role: .destructive) {
                            toggleDeletedState(itemToEdit)
                        }
                        Button("Cancel", role: .none) { }
                    }, message: {
                        Text("You can undo this action until you save the aircraft details.")
                            .font(.caption)
                    })
                }
            }

            // List is editable, so add the edit buttons
            if editable {
                Button(action: {
                    addItem()
                }, label: {
                    Text("Add")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 2)
                        .foregroundColor(.white)
                }).buttonStyle(.borderedProminent)
                    .tint(Color(.systemBlue))
                    .controlSize(.mini)
            }
        }
        .sheet(isPresented: $showAdd, onDismiss: {
            if itemToEdit.title == "" { return }
            items.append(itemToEdit)
            items.sort { lhs, rhs in lhs.actionDate! < rhs.actionDate! }
        }, content: {
            MaintenanceItemEditView(item: $itemToEdit)
        })
        .sheet(isPresented: $showEdit, onDismiss: {
            // Add a new item to the list using the details in the saved issue
            if let itemIndex = items.firstIndex(where: { $0.id == itemToEdit.id }) {
                items[itemIndex].title = itemToEdit.title
                items[itemIndex].action = itemToEdit.action
                items[itemIndex].actionDate = itemToEdit.actionDate
            }
            items.sort { lhs, rhs in lhs.actionDate! < rhs.actionDate! }
        }, content: {
            MaintenanceItemEditView(item: $itemToEdit)
        })
        .sheet(isPresented: $showIssue) {
            MaintenanceItemView(item: selectedItem!)
        }
    }
    
    private func listEditAction(_ editAction: maintenanceEditAction, _ item: AircraftMaintenanceModel) {
        switch editAction {
        case .view:
            viewItem(item)
        case .edit:
            editItem(item)
        case .delete:
            removeItem(item)
        }
    }
    
    private func addItem() {
        itemToEdit = AircraftMaintenanceModel(maintenanceItem: nil)
        showAdd.toggle()
    }
    
    private func editItem(_ item: AircraftMaintenanceModel) {
        itemToEdit = item
        showEdit.toggle()
    }
    
    private func viewItem(_ item: AircraftMaintenanceModel) {
        selectedItem = item
        showIssue.toggle()
    }

    private func removeItem(_ item: AircraftMaintenanceModel) {
        if item.isDeleted {
            toggleDeletedState(item)
            return
        }
        itemToEdit = item
        showDeleteConfirmation.toggle()
    }
    
    private func toggleDeletedState(_ item: AircraftMaintenanceModel) {
        if let itemIndex = items.firstIndex(where: { $0.id == item.id }) {
            items[itemIndex].isDeleted.toggle()
        }
    }
}
