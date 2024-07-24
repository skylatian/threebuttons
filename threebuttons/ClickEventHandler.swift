//
//  ClickEventHandler.swift
//  threebuttons
//
//  Created by skylatian on 7/24/24.
//

import Foundation
import Cocoa

class ClickEventHandler {
    func handle(type: ClickType, location: CGPoint) {
        switch type {
        case .leftDown, .leftUp:
            print("\(type.rawValue) at \(location)")
        case .middleDown, .middleUp:
            print("\(type.rawValue) at \(location)")
        case .rightDown, .rightUp:
            print("\(type.rawValue) at \(location)")
        }
    }
}


// below are unused, for now

// Example of how to use the new TouchZoneManager functionality
func updateTouchZones(with touches: [Touch]) {
    print("ZONNNEEE")
    let zoneManager = TouchZoneManager(touches: touches)
    let zoneFlags = zoneManager.isFingerInZone()
    print("Fingers in zones - Left: \(zoneFlags.left), Middle: \(zoneFlags.middle), Right: \(zoneFlags.right)")

}

func simulateClick(type: ClickType, at position: CGPoint) {
    print("Simulating \(type.rawValue) at \(position)")
    // Here you'd call another function to physically simulate the click
}
