//
// File: FlightEditViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 14/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import CoreData
import UtilityViews

class FlightEditViewModel: ObservableObject {
    
    // Title Page
    @Published var title: String
    @Published var expectedActivity: String
    @Published var selectedPilot: PickerOption?
    @Published var selectedAircraft: PickerOption?
    
    // Location page
    @Published var location: String
    @Published var weatherConditions: String
    @Published var siteConditions: String
    
    // Preflight page
    @Published var checksPerformed: Bool
    @Published var preflightIssues: [FlightIssueModel]
    @Published var issuesResolved: Bool
    
    // Flight page
    @Published var flightDetails: String
    @Published var takeOff: Date? {
        didSet {
            if takeOff == nil {
                landing = nil
            }
        }
    }
    @Published var landing: Date?
    @Published var flightIssues: [FlightIssueModel]
    
    // Notes page
    @Published var notes: String
    
    fileprivate var flightID: NSManagedObjectID?
    fileprivate var pilot: Pilot?
    fileprivate var aircraft: Aircraft?
    
    fileprivate var errors: [String] =  []
    var errorDigest: String { errors.joined(separator: "\n") }
    var hasErrors: Bool { !errors.isEmpty }
    
    var pilotList: [PickerOption] = []
    var currentPilot: PickerOption { selectedPilot
        ?? PickerOption(image: nil, title: "Tap to select pilot", subTitle: "")
    }
    
    var aircraftList: [PickerOption] = []
    var currentAircraft: PickerOption { selectedAircraft
        ?? PickerOption(image: nil, title: "Tap to select aircract", subTitle: "")
    }
    
    var hasTakeoffDate: Bool {
        takeOff != nil
    }
    
    var duration: String {
        guard let takeOffDate = takeOff,
                let landingDate = landing else {
            return "N/A"
        }
        let duration = landingDate - takeOffDate
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        
        return formatter.string(from: duration) ?? "N/A"
    }
    
    init(flightID: NSManagedObjectID?) {
        
        if let flightID {
            self.flightID = flightID

            let flight = Flight.byId(id: flightID) ?? Flight.dummyData
            
            self.pilot = flight.pilot
            self.aircraft = flight.aircraft
            
            title = flight.title ?? ""
            expectedActivity = flight.activity ?? ""
            
            location = flight.location ?? ""
            weatherConditions = flight.weatherConditions ?? ""
            siteConditions = flight.siteConditions ?? ""
            
            checksPerformed = flight.preflightChecks
            if let pfi = flight.preflightIssues as? Set<FlightIssue> {
                preflightIssues = pfi.map { FlightIssueModel(flightIssue: $0) }
            } else {
                preflightIssues = []
            }
            issuesResolved = flight.preflightIssuesResolved
            
            flightDetails = flight.details ?? ""
            takeOff = flight.takeoff
            landing = flight.landing
            
            if let fli = flight.flightIssues as? Set<FlightIssue> {
                flightIssues = fli.map { FlightIssueModel(flightIssue: $0)}
            } else {
                flightIssues = []
            }
            
            notes = flight.notes ?? ""
            
        } else {
            self.flightID = nil
            
            title = ""
            expectedActivity = ""
            location = ""
            weatherConditions = ""
            siteConditions = ""
            
            checksPerformed = false
            preflightIssues = []
            issuesResolved = false
            
            flightDetails = ""
            takeOff = nil
            landing = nil
            flightIssues = []

            notes = ""
        }
        
        loadPickerLists()
    }
    
    func loadPickerLists() {
        pilotList = Pilot.pickerData()
        aircraftList = Aircraft.pickerData()
        
        if let pilot {
            // Load selected pilot picker option
            selectedPilot = pilotList.first(where: { pl in
                guard let picker = pl as? PickerOptionWithKey else { return false }
                return picker.managedObjectID == pilot.objectID
            })
        }
        
        if let aircraft {
            selectedAircraft = aircraftList.first(where: { ac in
                guard let picker = ac as? PickerOptionWithKey else { return false }
                return picker.managedObjectID == aircraft.objectID
            })
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func save() {

        var flight: Flight

        if let flightID {
            flight = Flight.byId(id: flightID) as! Flight
        } else {
            flight = Flight.create()
            flight.deletedDate = nil
        }
        
        if flight.title != title { flight.title = title }
        if flight.activity != expectedActivity { flight.activity = expectedActivity }
        
        if flight.location != location { flight.location = location }
        if flight.weatherConditions != weatherConditions { flight.weatherConditions = weatherConditions }
        if flight.siteConditions != siteConditions { flight.siteConditions = siteConditions }
        
        if flight.preflightChecks != checksPerformed { flight.preflightChecks = checksPerformed }
        updateIssues(inFlight: flight,
                     fromIssues: flight.preflightIssues as? Set<FlightIssue>,
                     toIssues: preflightIssues,
                     isPreFlight: true)
        if flight.preflightIssuesResolved != issuesResolved { flight.preflightIssuesResolved = issuesResolved }
        
        if flight.details != flightDetails { flight.details = flightDetails }
        if flight.takeoff != takeOff { flight.takeoff = takeOff }
        if flight.landing != landing { flight.landing = landing }

        updateIssues(inFlight: flight,
                     fromIssues: flight.flightIssues as? Set<FlightIssue>,
                     toIssues: flightIssues,
                     isPreFlight: false)

        if flight.notes != notes { flight.notes = notes }
        
        updatePilot(inFlight: flight)
        updateAircraft(inFlight: flight)
        
        flight.save()
        
        MessageCenter.send(Notification.Name.flightUpdated, withData: flight.objectID)
    }
    // swiftlint:enable cyclomatic_complexity
    
    private func updatePilot(inFlight flight: Flight) {
        if let pilot = selectedPilot as? PickerOptionWithKey {
            if flight.pilot?.objectID != pilot.managedObjectID {
                flight.pilot = Pilot.byId(id: pilot.managedObjectID)
            }
        }
    }
    
    private func updateAircraft(inFlight flight: Flight) {
        if let aircraft = selectedAircraft as? PickerOptionWithKey {
            if flight.aircraft?.objectID != aircraft.managedObjectID {
                flight.aircraft = Aircraft.byId(id: aircraft.managedObjectID)
            }
        }
    }
    
    private func updateIssues(inFlight: Flight, fromIssues issues: Set<FlightIssue>?,
                              toIssues modifiedIssues: [FlightIssueModel], isPreFlight: Bool) {
        
        let itemsToDelete = modifiedIssues.filter { issue in issue.isDeleted && issue.id != nil }
        let itemsToAdd = modifiedIssues.filter { issue in issue.id == nil && issue.isDeleted == false }
        let itemsToUpdate = modifiedIssues.filter { issue in issue.hasChanged && issue.id != nil }
        
        for toDelete in itemsToDelete {
            StorageProvider.shared.context.delete((issues?.first(where: {
                $0.objectID == toDelete.flightIssue?.objectID
            }))!)
        }
        for toUpdate in itemsToUpdate {
            if let issue = issues?.first(where: {$0.objectID == toUpdate.flightIssue?.objectID}) {
                issue.title = toUpdate.title
                issue.notes = toUpdate.notes
                issue.resolved = toUpdate.resolved
            }
        }
        for toAdd in itemsToAdd {
            let newFlight = FlightIssue.create() as FlightIssue
            newFlight.title = toAdd.title
            newFlight.notes = toAdd.notes
            newFlight.resolved = toAdd.resolved
            if isPreFlight {
                newFlight.preflightissues = inFlight
            } else {
                newFlight.flightIssues = inFlight
            }
        }
    }
    
    func canSave() -> Bool {
        errors = []

        if Validators.isRequiredFieldEmpty(title) { errors.append("Please add a title for the activity")}
        
        if Validators.isValueNil(selectedPilot) { errors.append("You must select a pilot")}
        if Validators.isValueNil(selectedAircraft) { errors.append("You must select an aitcraft")}

        return errors.isEmpty
    }
    
    func validateDuration() -> Bool {
        guard let takeoffDate = takeOff, let landingDate = landing else { return true }
        let duration = landingDate - takeoffDate
        
        // Duration will be a value in seconds. We want to trap durations over 60 minutes
        if duration > 60 * 60 {
            return false
        }
        return true
    }
}

struct FlightIssueModel: Hashable {
    
    var flightIssue: FlightIssue?
    
    var id: NSManagedObjectID? {
        flightIssue?.objectID ?? nil
    }
    
    init(flightIssue: FlightIssue?) {
        if let flightIssue {
            self.flightIssue = flightIssue
            title = flightIssue.title ?? ""
            notes = flightIssue.notes ?? ""
            resolved = flightIssue.resolved
        } else {
            title = ""
            notes = ""
            resolved = false
        }
        
        isDeleted = false
    }
    
    var title: String { didSet { listId = UUID() } }
    var notes: String { didSet { listId = UUID() } }
    var resolved: Bool { didSet { listId = UUID() } }
    
    // Used to help rebuild the list when it is saved. We give users the chance to delete an
    // issue, but they get the chance to undelete it right up until they save the data.
    var isDeleted: Bool { didSet { listId = UUID() } }
    
    // Used to force a list refresh. By changing the listId, we force any list to refresh the
    // specific issue. If we don't do this, SwiftUI will reuse the old cell view as it will decide
    // that it hasn't changed.
    var listId: UUID = UUID()
    
    var hasChanged: Bool {
        if title != flightIssue?.title { return true }
        if notes != flightIssue?.notes { return true }
        if resolved != flightIssue?.resolved { return true }
        return false
    }
}
