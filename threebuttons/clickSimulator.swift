//
//  clickSimulator.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24.
//

import Foundation
import SwiftUI

import Cocoa

func simulateClick(button: CGMouseButton, direction: Bool) {

    let button = button
    let dir = direction
    
    // print(button.rawValue, dir)
    
    let currentMouseLocation = NSEvent.mouseLocation
    let screenBounds = NSScreen.main?.frame.size ?? CGSize(width: 1440, height: 900) // Default screen size if screen detection fails
    let correctedPosition = CGPoint(x: currentMouseLocation.x, y: screenBounds.height - currentMouseLocation.y) // Correct for flipped Y coordinate
    print(correctedPosition)

    
    mouseClick(point: correctedPosition, mouseButton: button, dir: dir)
    
    // let source = CGEventSource(stateID: .combinedSessionState)
    
    // let currentMouseLocation = NSEvent.mouseLocation
    // let location = CGEventTapLocation.cghidEventTap
    
    }

func mouseClick(point: CGPoint, mouseButton: CGMouseButton, dir: Bool) {
    
    // https://gist.github.com/vorce/04e660526473beecdc3029cf7c5a761c
    
    switch dir
    {
    case true:
        // down
        print("down")
        //CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseDown, mouseCursorPosition: point, mouseButton: mouseButton)?.post(tap: CGEventTapLocation.cghidEventTap)
        
    case false:
        // up
        print("up")
        //CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseUp, mouseCursorPosition: point, mouseButton: mouseButton)?.post(tap: CGEventTapLocation.cghidEventTap)
    }
   
}
// Example usage
// simulateMiddleMouseClick(at: CGPoint(x: 100, y: 100))
