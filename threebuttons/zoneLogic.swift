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
            return (.outside, .green)
        }
        if normalizedX < 0.4 {
            return (.left, .blue)
        } else if normalizedX >= 0.4 && normalizedX <= 0.6 {
            return (.middle, .white)
        } else {
            return (.right, .red)
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
    
    private init() { }
    
}
