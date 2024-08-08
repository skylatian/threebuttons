//
//  zoneLogic.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24


import SwiftUI

struct ZoneLogic {
    static func determineZone(for touch: Touch) -> (zone: Zone, color: Color) {
        let normalizedX = touch.normalizedX
        let normalizedY = touch.normalizedY
        guard normalizedY >= 0.85 else {
            return (.outside, .green) // probably don't need the guard statement here but it's not hurting anything
        }
        if normalizedX >= Settings.shared.leftZoneStart && normalizedX < Settings.shared.leftZoneEnd {//&& Settings.shared.enableLeftZone == true {
            //print("finger in left zone")
            return (.left, .blue)
        } else if normalizedX >= Settings.shared.midZoneStart && normalizedX <= Settings.shared.midZoneEnd {//&& Settings.shared.enableMidZone == true {
            //print("finger in middle zone")
            return (.middle, .white)
        } else if normalizedX > Settings.shared.rightZoneStart && normalizedX <= Settings.shared.rightZoneEnd {//&& Settings.shared.enableRightZone == true {
            //print("finger in right zone")
            return (.right, .red)
        }
        else
        {
            // for the wild ones who want spaces between their zones
            return (.outside, .green)
        }
    }
}

enum Zone {
        case left
        case middle
        case right
        case outside
    }

class zoneStatus: ObservableObject {
    
    static let shared = zoneStatus() // now accessible as zoneStatus.shared
    
    @Published var inLeft: Bool = false // defaults 
    @Published var inMid: Bool = false
    @Published var inRight: Bool = false
    @Published var outside: Bool = false
    
    private init() { }
    
}

class ZoneTracker {
    static let shared = ZoneTracker() // Singleton instance

    enum Zone {
        case left
        case middle
        case right
        case outside // Represents no zone
    }

    var lastActiveZone: Zone = .outside {
        didSet {
            print("Active zone changed to: \(lastActiveZone)")
        }
    }
}
