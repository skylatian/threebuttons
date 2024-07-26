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
    static func handle(clickType: ClickType, location: CGPoint) {
        //print("\(clickType.rawValue) detected at \(location)")
        // Implement any additional handling based on click type or location
        
        // you'll  want to modify this a lot
        //
        // it needs to handle all the clicks, yes, but it also
        // needs to determine which click to perform. that'll
        // come from the function that detects fingers on the
        // trackpad - you'll probably want to mod that to
        // output a true/false value for left/mid/right clicks
        // based on if there's a finger present on the trackpad
        // there.
        
        // something like from the callback)
        // if click(type: anybutton, direction: down) detected and finger_present_in_middle_zone = true
        //      simulate middle click down
        // if click(type: anybutton, direction: UP) detected and finger_present_in_middle_zone = true
        //      simulate middle click UP
        // etc
        
        switch clickType {
        case .leftDown:
            print("Left Click Down Detected")
        case .rightDown:
            print("Right Click Down Detected")
        case .middleDown:
            print("Middle Click Down Detected")
        case .leftUp:
            print("Left Click Up Detected")
        case .rightUp:
            print("Right Click Up Detected")
        case .middleUp:
            print("Middle Click Up Detected")
        }
    }
}

