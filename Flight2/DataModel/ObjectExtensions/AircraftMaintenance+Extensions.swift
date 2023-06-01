//
// File: AircraftMaintenance+Extensions.swift
// Package: Flight2
// Created by: Steven Barnett on 03/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI

extension AircraftMaintenance {
    var viewTitle: String { self.title ?? "" }
    var viewAction: String { self.action ?? "" }
    var viewActionDate: Date? { self.actionDate }
    
    var viewDate: String {
        if let action = self.actionDate { return action.appDate }
        return "Not set"
    }
}

extension AircraftMaintenance: BaseModel {

}
