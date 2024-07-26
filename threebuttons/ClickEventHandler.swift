//
//  ClickEventHandler.swift
//  threebuttons
//
//  Created by skylatian on 7/24/24.
//

import Foundation
import Cocoa

class ClickEventHandler {
    var touches: [Touch] = []
    
    func handle(type: ClickType, location: CGPoint) {
        // print("handle") // this does run
        // updateTouchZones()
        let zoneManager = TouchZoneManager(touches: touches)
        let zoneFlags = zoneManager.isFingerInZone()
        // print(zoneFlags) // this runs!
        print(ZoneStatusTracker.shared.isLeftZoneActive, ZoneStatusTracker.shared.isMiddleZoneActive, ZoneStatusTracker.shared.isRightZoneActive) // this runs!! 👀 but zones aren't detected
        switch type {
        case .leftDown, .leftUp:
            print("\(type.rawValue) at \(location)")
            //print(ZoneStatusTracker.shared.isLeftZoneActive) // this runs!! 👀
        case .middleDown, .middleUp:
            print("\(type.rawValue) at \(location)")
        case .rightDown, .rightUp:
            print("\(type.rawValue) at \(location)")
        }
    }
    
    func checkForSpecialZones(in touches: [Touch]) -> [String] {
        print("vroom")
        var results: [String] = []
        let zoneManager = TouchZoneManager(touches: touches)

        for touch in touches {
            switch zoneManager.determineZone(normalizedX: touch.normalizedX, normalizedY: touch.normalizedY) {
            case .left:
                results.append("Blue circle detected")
            case .middle:
                results.append("White circle detected")
            case .right:
                results.append("Red circle detected")
            case .outside:
                results.append("Green circle detected")
            }
        }
        
        return results
    }

    
}


// below are unused, for now

// Example of how to use the new TouchZoneManager functionality
func updateTouchZones(with touches: [Touch]) {
    print("ZONNNEEE") // this never runs
    let zoneManager = TouchZoneManager(touches: touches)
    let zoneFlags = zoneManager.isFingerInZone()
    print("Fingers in zones - Left: \(zoneFlags.left), Middle: \(zoneFlags.middle), Right: \(zoneFlags.right)")

}

func simulateClick(type: ClickType, at position: CGPoint) {
    print("Simulating \(type.rawValue) at \(position)")
    // Here you'd call another function to physically simulate the click
}
