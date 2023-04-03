//
// File: Date+Extensions.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 21/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import Foundation

extension Date {
    
    var appDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        return formatter.string(from: self)
    }
    
    var appDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy - HH:mm"
        
        return formatter.string(from: self)
    }
    
    var appTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
