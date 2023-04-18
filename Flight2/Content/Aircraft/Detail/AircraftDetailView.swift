//
// File: AircraftDetailView.swift
// Package: Flight2
// Created by: Steven Barnett on 10/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var vm: AircraftDetailViewModel
    @State var readonlyModal: Bool = false
    @State private var editAircraft: Bool = false
    @State private var isPresentingDeleteConfirm: Bool = false
    
    var body: some View {
        if vm.aircraftId == nil {
            NothingSelectedView()
        } else {
            VStack {
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
                            Text(vm.aircraft.viewModel).font(.title2)
                            Text("s/n \(vm.aircraft.viewSerialNumber)").font(.title2)
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
                
                if vm.aircraft.aircraftDeleted {
                    HStack {
                        Spacer()
                        Text("This aircraft has been deleted")
                            .padding(.vertical, 2)
                        Spacer()
                    }.background(Color(.systemRed))
                        .padding(.vertical, 2)
                }
                
                List {
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        Section(content: {
                            DetailLine(key: "Name", value: vm.aircraft.viewName)
                            DetailLine(key: "Manufacturer", value: vm.aircraft.viewManufacturer)
                            DetailLine(key: "Model", value: vm.aircraft.viewModel)
                            DetailLine(key: "Serial Number", value: vm.aircraft.viewSerialNumber)
                        }, header: {
                            SectionTitle("Aircraft")
                        })
                    }
                    
                    if vm.aircraft.hasPurchaseData {
                        Section(content: {
                            DetailLine(key: "From", value: vm.aircraft.viewPurchasedFrom)
                            DetailLine(key: "On", value: vm.aircraft.formattedPurchaseDate)
                            DetailLine(key: "New?", value: vm.aircraft.viewNewAtPurchase)
                        }, header: {
                            SectionTitle("Purchase Info")
                        })
                    }
                    
                    Section(content: {
                        HStack {
                            Text(vm.aircraft.viewNotes)
                                .lineLimit(10)
                            Spacer()
                        }.padding(.horizontal, 16)
                    }, header: {
                        SectionTitle("Notes")
                    })
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !readonlyModal {
                    ToolbarItemGroup(placement: .primaryAction) {
                        HStack {
                            if !vm.aircraft.aircraftDeleted {
                                Button(action: {
                                    editAircraft = true
                                }, label: {
                                    Image(systemName: "square.and.pencil")
                                })
                            }
                            Button(action: {
                                deleteAircraft()
                            }, label: {
                                Image(systemName: vm.aircraft.aircraftDeleted ? "trash.slash" : "trash")
                            })
                            .confirmationDialog("Are you sure?",
                                                isPresented: $isPresentingDeleteConfirm,
                                                actions: {
                                Button("Delete aircraft?", role: .destructive) {
                                    vm.deleteAircraft()
                                }
                            }, message: {
                                Text("You can undo this action later if necessary.")
                            })
                        }
                    }
                }
            }
            .sheet(isPresented: $editAircraft,
                   onDismiss: { vm.reloadData()
            }, content: {
                AircraftEdit(editViewModel: AircraftEditViewModel(aircraftID: vm.aircraft.objectID))
            })

            .interactiveDismissDisabled(true)
            .overlay(alignment: .topTrailing) {
                if readonlyModal {
                    Button(action: {
                        dismiss()
                    }, label: {
                        XDismissButton()
                    })
                }
            }
        }
    }
    
    func deleteAircraft() {
        if vm.aircraft.aircraftDeleted {
            vm.undeleteAircraft()
            vm.reloadData()
        } else {
            isPresentingDeleteConfirm = true
        }
    }
}
