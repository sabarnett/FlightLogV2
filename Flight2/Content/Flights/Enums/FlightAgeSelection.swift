//
// File: FlightAgeSelection.swift
// Package: Flight2
// Created by: Steven Barnett on 29/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation

enum FlightAgeSelection: Int, CaseIterable, CustomStringConvertible {
    case lastWeek
    case lastMonth
    case threeMonths
    case sixMonths
    case year
    case allFlights
    
    var description: String {
        switch self {
        case .lastWeek:
            return "Last 7 Days"
        case .lastMonth:
            return "Last Month"
        case .threeMonths:
            return "Last 3 Months"
        case .sixMonths:
            return "Last 6 Months"
        case .year:
            return "Last 12 Months"
        case .allFlights:
            return "All"
        }
    }
}
