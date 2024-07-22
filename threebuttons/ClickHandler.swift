//
//  clickCallback.swift
//  threebuttons
//
//  Created by skylatian on 7/21/24.
//

// this file is (will be) where clicks are ultimately dealt with (pass, pass but modify, not pass, etc)

import Foundation
import CoreGraphics

class ClickHandler {
    // Function to simulate a mouse click
    
    
    static func simulateClick(type: ClickType, at position: CGPoint) {
        print("Simulating \(type.rawValue) at \(position)")
        // Here you'd call another function to physically simulate the click
    }

    // Handle detected clicks by determining which zone the click should be simulated in
    static func handle(clickType: ClickType, location: CGPoint, touches: [Touch]) {
        let cursorPosition = CursorPosition.shared.getPosition()
        print("\(clickType.rawValue) detected at \(location), cursor at \(cursorPosition), zones:)")
        
        // Example of how to use the new TouchZoneManager functionality
        func updateTouchZones(with touches: [Touch]) {
            print("ZONNNEEE")
            let zoneManager = TouchZoneManager(touches: touches)
            let zoneFlags = zoneManager.isFingerInZone()
            print("Fingers in zones - Left: \(zoneFlags.left), Middle: \(zoneFlags.middle), Right: \(zoneFlags.right)")
        
        }
    }

}
