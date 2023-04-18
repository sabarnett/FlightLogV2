//
// File: FlightDetailViewModel.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import CoreData

class FlightDetailViewModel: ObservableObject {
    
    @Published var flight: Flight
    @Published var flightId: NSManagedObjectID?
    
    init(flight: Flight) {
        flightId = flight.objectID
        self.flight = flight
        
        loadIssues()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sectionChanged),
                                               name: Notification.Name.sectionChanged,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.sectionChanged,
                                                  object: nil)
    }
    
    @objc func sectionChanged() {
        flightId = nil
    }
    
    var flightIssueSet: [FlightIssueModel] = []
    var preFlightIssueSet: [FlightIssueModel] = []
    
    var title: String { flight.title ?? "" }
    var activity: String { flight.activity ?? "" }
    
    var location: String { flight.location ?? "" }
    var weatherConditions: String { flight.weatherConditions ?? "" }
    var siteConditions: String { flight.siteConditions ?? "" }
    
    var preflightChecksPerformed: Bool { flight.preflightChecks }
    var preflightIssuesResolved: Bool { flight.preflightIssuesResolved }
    var preflightIssues: [FlightIssueModel] {
        get { preFlightIssueSet }
        set { preFlightIssueSet = newValue }
    }
    
    var takeOff: Date? { flight.takeoff}
    var landing: Date? { flight.landing }
    var details: String { flight.details ?? ""}
    var flightIssues: [FlightIssueModel] {
        get { flightIssueSet }
        set { flightIssueSet = newValue }
    }
    
    var notes: String { flight.notes ?? "" }
    
    var pilot: Pilot { flight.pilot ?? Pilot.dummyData }
    var profileImage: UIImage { pilot.profileImage?.image ?? UIImage(named: "person-placeholder")!}
    
    var aircraft: Aircraft { flight.aircraft ?? Aircraft.dummyData }
    var aircraftImage: UIImage { aircraft.aircraftImage?.image ?? UIImage(named: "plane-placeholder")!}

    var isDeleted: Bool { flight.deletedDate != nil }
    
    var takeoffDateTime: String {
        guard let takeoff = flight.takeoff else { return "Not known" }
        return takeoff.appDateTime
    }
    
    var takeoffDate: String {
        guard let takeoff = flight.takeoff else { return "Not known" }
        return takeoff.appDate
    }
    
    var takeoffTime: String {
        guard let takeoff = flight.takeoff else { return "" }
        return takeoff.appTime
    }
    
    var landingDateTime: String {
        guard let landing = flight.landing else { return "not known" }
        return landing.appDateTime
    }
    
    var landingDate: String {
        guard let landing = flight.landing else { return "not known" }
        return landing.appDate
    }
    
    var landingTime: String {
        guard let landing = flight.landing else { return "" }
        return landing.appTime
    }
    
    var canDelete: Bool {
        // We can only delete a flight if it:
        // - Has neither take-off or landing dates
        // - Has both take-off and landing dates.
        // You cannot delete a flight that has a take-off but no landing.
        if takeOff == nil && landing == nil {
            return true
        }
        if takeOff != nil && landing != nil {
            return true
        }
        
        return false
    }
    
    var flightDuration: String {
        guard let takeOffDate = takeOff,
                let landingDate = landing else {
            return "N/A"
        }
        let duration = landingDate - takeOffDate
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        
        return formatter.string(from: duration) ?? "N/A"
    }
    
    func reloadData() {
        self.flight = Flight.byId(id: flight.objectID) ?? Flight.dummyData
        loadIssues()
    }
    
    func deleteFlight() {
        setDeletedState(forFlight: self.flight, isDeleted: true)
    }
    
    func undeleteFlight() {
        setDeletedState(forFlight: self.flight, isDeleted: false)
    }
    
    private func setDeletedState(forFlight flight: Flight, isDeleted: Bool) {
        flight.deletedDate = isDeleted ? Date() : nil
        flight.save()
    }
    
    private func loadIssues() {
        if let pfi = self.flight.preflightIssues as? Set<FlightIssue> {
            preFlightIssueSet = pfi.map { FlightIssueModel(flightIssue: $0) }
        }
        if let fli = self.flight.flightIssues as? Set<FlightIssue> {
            flightIssueSet = fli.map { FlightIssueModel(flightIssue: $0)}
        }
    }
}
