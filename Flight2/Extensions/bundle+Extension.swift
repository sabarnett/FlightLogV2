//
// File: bundle+Extension.swift
// Package: Flight2
// Created by: Steven Barnett on 29/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v \(releaseVersionNumber ?? "1.0.0")"
    }
    var releaseAndBuildVersionNumberPretty: String {
        return "v \(releaseVersionNumber ?? "1.0").\(buildVersionNumber ?? ".0")"
    }
        
    var displayName: String {
            return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String ??
                "RC Flight Log"
    }
}
