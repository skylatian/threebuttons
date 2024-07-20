//
//  TouchDataModel.swift
//  threebuttons
//
//
//  Created by skylatian on 7/19/24.
//

import Foundation
import AppKit

import Foundation

class TouchDataModel {
    static let shared = TouchDataModel()
    var topQuarterTouchesActive = false {
        didSet {
            // You could trigger additional actions here if needed when the value changes.
            //print("Top Quarter Touches Active: \(topQuarterTouchesActive)")
        }
    }
}
