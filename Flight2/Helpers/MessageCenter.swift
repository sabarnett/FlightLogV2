//
// File: MessageCenter.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 27/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//
        

import Foundation

class MessageCenter {
    static func send(_ message: Notification.Name, withData objectData: Any? = nil) {
        NotificationCenter.default.post(name: message, object: objectData)
    }
}

extension Notification.Name {
    static let pilotUpdated = Notification.Name("PilotUpdated")
    static let aircraftUpdated = Notification.Name("AircraftUpdated")
    static let flightUpdated = Notification.Name("FlightUpdated")
    static let sectionChanged = Notification.Name("sectionChanged")
}
