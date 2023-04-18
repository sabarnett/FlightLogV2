//
// File: SavedImage+CoreDataProperties.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 26/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//
        
//

import Foundation
import CoreData
import SwiftUI

extension SavedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedImage> {
        return NSFetchRequest<SavedImage>(entityName: "SavedImage")
    }

    @NSManaged public var image: UIImage?
    @NSManaged public var profileImage: Pilot?

}

extension SavedImage: Identifiable {

}
