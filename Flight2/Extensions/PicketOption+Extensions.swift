//
// File: PicketOption+Extensions.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 22/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI
import CoreData
import UtilityViews

class PickerOptionWithKey: PickerOption {

    var managedObjectID: NSManagedObjectID
    
    init(image: UIImage? = nil, title: String, subTitle: String, managedObjectID: NSManagedObjectID) {
        self.managedObjectID = managedObjectID
        
        super.init(image: image,
                   title: title,
                   subTitle: subTitle)
    }
    
}
