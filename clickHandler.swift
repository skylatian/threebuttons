//
//  clickHandler.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24.
//

// this file is (will be) where clicks are ultimately dealt with (pass, pass but modify, not pass, etc)

import Foundation
import CoreGraphics

class ClickHandler {
    static func handle(clickType: Bool, location: CGPoint) {
        //print("\(clickType) detected at \(location)")
        
        
        switch clickType {
            
        case false:
            //print("click up")
            if zoneStatus.shared.inLeft
            {
                //print("simulate left click up")
                simulateClick(button: .left, direction: false) // false is up, true is down
                
            }
            if zoneStatus.shared.inMid
            {
                //print("simulate middle click up")
                simulateClick(button: .center, direction: false)
            }
            if zoneStatus.shared.inRight
            {
                //print("simulate right click up")
                simulateClick(button: .right, direction: false)
            }

        case true:
            //print("click down")
            if zoneStatus.shared.inLeft
            {
                //print("simulate left click down")
                simulateClick(button: .left, direction: true) // false is up, true is down
            }
            if zoneStatus.shared.inMid
            {
                //print("simulate middle click down")
                simulateClick(button: .center, direction: true)
            }
            if zoneStatus.shared.inRight
            {
                //print("simulate right click down")
                simulateClick(button: .right, direction: true)
            }
            
            
        }

    }
}
