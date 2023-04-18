//
// File: ViewStyleToggle.swift
// Package: Flight2
// Created by: Steven Barnett on 28/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

enum ViewStyleToggle: String, CaseIterable {
    case list
    case card
    case grid
    
    var nextStyle: ViewStyleToggle {
        switch self {
        case .list:
            return .card
        case .card:
            return .grid
        case .grid:
            return .list
        }
    }
    
    var imageName: String {
        switch self {
        case .list:
            return "list.bullet"
        case .card:
            return "doc.text.image"
        case .grid:
            return "square.grid.2x2"
        }
    }
}
