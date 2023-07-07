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
    @State private var showReport: Bool = false
    
    var body: some View {
        if vm.aircraftId == nil {
            NothingSelectedView()
        } else {
            VStack {
                AircraftDetailHeading(vm: vm)
                AircraftDeletedIndicator(vm: vm)

                List {
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        AircraftBasicDetail(vm: vm)
                    }
                    AircraftDetails(vm: vm)
                    AircraftPurchaseDetail(vm: vm)
                    AircraftDetailNotes(vm: vm)
                    AircraftStatisticsView(vm: vm)
                    AircraftMaintenanceLog(vm: vm)
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
                            
                            Button(action: {createReport() },
                                   label: { Image(systemName: "doc.richtext")})
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showReport) {
                ShowReport(reportTitle: "Pilot Report", pdfData: vm.pdfReport)
            }
            .fullScreenCover(isPresented: $editAircraft, onDismiss: {
                vm.reloadData()
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
    
    func createReport() {
        showReport = vm.generateReport()
    }
}
