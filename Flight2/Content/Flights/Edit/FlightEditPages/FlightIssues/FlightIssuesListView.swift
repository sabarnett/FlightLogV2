//
// File: FlightIncidentView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 11/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct FlightIssuesListView: View {
    
    @Binding var issues: [FlightIssueModel]
    @State var editable: Bool = false
    @State var selectedIncident: FlightIssueModel?
    @State var viewTitle: String = "Issues"
    @State var showAdd: Bool = false
    @State var showEdit: Bool = false
    @State var showIssue: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var issueToEdit: FlightIssueModel = FlightIssueModel(flightIssue: nil)
    
    var body: some View {
        VStack {
            HStack {
                Text(viewTitle)
                    .font(.caption)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.bottom, 3)
                Spacer()
            }
            if issues.count == 0 {
                VStack {
                    Text("No issues logged")
                        .foregroundColor(Color(.placeholderText))
                    Spacer()
                }
            } else {
                VStack {
                    List(issues, id: \.listId, selection: $selectedIncident) { issue in
                        FlightIssueCell(issue: issue,
                                        editable: editable,
                                        onEditAction: listEditAction)
                            .listRowBackground(Color(.secondarySystemBackground))
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .confirmationDialog("Are you sure?", isPresented: $showDeleteConfirmation, actions: {
                        Button("Delete issue???", role: .destructive) {
                            toggleDeletedState(issueToEdit)
                        }
                        Button("Cancel", role: .none) { }
                    }, message: {
                        Text("You can undo this action until you save the flight details.")
                            .font(.caption)
                    })
                }
            }
            
            // List is editable, so add the edit buttons
            if editable {
                Button(action: {
                    addIssue()
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
            if issueToEdit.title == "" {
                print("User cancelled from the add")
                return
            }
            
            print("Edit Dismissed, user saved the add. So add a record to the list")
            issues.append(issueToEdit)
        }, content: {
            FlightIssueEditView(issue: $issueToEdit)
        })
        .sheet(isPresented: $showEdit, onDismiss: {
            // Add a new issue to the list using the details in the saved issue
            if let issueIndex = issues.firstIndex(where: { $0.id == issueToEdit.id }) {
                issues[issueIndex].title = issueToEdit.title
                issues[issueIndex].notes = issueToEdit.notes
                issues[issueIndex].resolved = issueToEdit.resolved
            }
        }, content: {
            FlightIssueEditView(issue: $issueToEdit)
        })
        .sheet(isPresented: $showIssue) {
            FlightIssueView(issue: selectedIncident!)
        }

    }
    
    private func listEditAction(_ editAction: flightIssueEditAction, _ issue: FlightIssueModel) {
        switch editAction {
        case .view:
            viewIssue(issue)
        case .edit:
            editIssue(issue)
        case .delete:
            removeIssue(issue)
        case .resolve:
            resolveIssue(issue)
        }
    }
    
    private func addIssue() {
        issueToEdit = FlightIssueModel(flightIssue: nil)
        showAdd.toggle()
    }
    
    private func editIssue(_ issue: FlightIssueModel) {
        issueToEdit = issue
        showEdit.toggle()
    }
    
    private func viewIssue(_ issue: FlightIssueModel) {
        selectedIncident = issue
        showIssue.toggle()
    }
    
    private func resolveIssue(_ issue: FlightIssueModel) {
        if let issueIndex = issues.firstIndex(where: { $0.id == issue.id }) {
            issues[issueIndex].resolved.toggle()
        }
    }
    
    private func removeIssue(_ issue: FlightIssueModel) {
        if issue.isDeleted {
            toggleDeletedState(issue)
            return
        }
        issueToEdit = issue
        showDeleteConfirmation.toggle()
    }
    
    private func toggleDeletedState(_ issue: FlightIssueModel) {
        if let issueIndex = issues.firstIndex(where: { $0.id == issue.id }) {
            issues[issueIndex].isDeleted.toggle()
        }
    }
}

struct FlightIncidentView_Previews: PreviewProvider {
    
    @State static var incidents = [
        FlightIssueModel(flightIssue: FlightIssue.dummyData),
        FlightIssueModel(flightIssue: FlightIssue.dummyData),
        FlightIssueModel(flightIssue: FlightIssue.dummyData)
    ]
    
    static var previews: some View {
        FlightIssuesListView(issues: $incidents)
    }
}
