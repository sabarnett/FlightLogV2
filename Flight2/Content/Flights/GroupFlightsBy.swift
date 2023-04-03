//
// File: GroupFlightsBy.swift
// Package: Flight2
// Created by: Steven Barnett on 29/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import Foundation

enum GroupFlightsBy: Int, CaseIterable, CustomStringConvertible {
    case pilot
    case aircraft
    
    var description: String {
        switch self {
        case .pilot: return "Pilot"
        case .aircraft: return "Aircraft"
        }
    }
}
