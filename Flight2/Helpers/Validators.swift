//
// File: Validators.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import Foundation

class Validators {
    
    static func isRequiredFieldEmpty(_ value: String?) -> Bool {
        guard let testValue = value else { return true }
        if testValue.trimmingCharacters(in: .whitespacesAndNewlines) == "" { return true }
        
        return false
    }
    
    static func isValidEmail(_ value: String?) -> Bool {
        guard let testValue = value else { return true }

        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^(\\D)+(\\w)*((\\.(\\w)+)?)+@(\\D)+(\\w)*((\\.(\\D)+(\\w)*)+)?(\\.)[a-z]{2,}$")
        return emailTest.evaluate(with: testValue)
    }
    
    static func isValueNil(_ value: Any?) -> Bool {
        value == nil
    }
}
