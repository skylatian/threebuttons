//
//  clickTracker.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24.
//

import Cocoa
import CoreGraphics

class EventTapClickDetector {
    var eventTap: CFMachPort?
    var runLoopSource: CFRunLoopSource?

    init() {
        setupEventTap()
    }

    deinit {
        stopEventTap()
    }

    private func setupEventTap() {
        let eventMask = (1 << CGEventType.leftMouseDown.rawValue) |
                        (1 << CGEventType.rightMouseDown.rawValue) |
                        (1 << CGEventType.otherMouseDown.rawValue) |
                        (1 << CGEventType.leftMouseUp.rawValue) |
                        (1 << CGEventType.rightMouseUp.rawValue) |
                        (1 << CGEventType.otherMouseUp.rawValue)
        
        eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                     place: .headInsertEventTap,
                                     options: .defaultTap,
                                     eventsOfInterest: CGEventMask(eventMask),
                                     callback: myEventTapCallback,
                                     userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        if let eventTap = eventTap {
            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        } else {
            print("Failed to create event tap")
        }
    }

    private func stopEventTap() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            if let runLoopSource = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            }
            self.eventTap = nil
            self.runLoopSource = nil
        }
    }
}

enum MouseButton {
    case left
    case right
    case middle
}

private func modifyMouseEvent(event: CGEvent, newButtonType: MouseButton, newEventType: CGEventType) -> CGEvent? {
    // currently unused
    // Set the mouse button type
    switch newButtonType {
    case .left:
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
    case .right:
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
    case .middle:
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
    }

    //event.type = newEventType // Set the new event type - unsure if needed

    return event
}

// Variables to track the button states and last active zone
var leftButtonDown = false
var rightButtonDown = false
var middleButtonDown = false
var lastActiveButton: MouseButton?

private func myEventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    //let clickDetector = Unmanaged<EventTapClickDetector>.fromOpaque(refcon!).takeUnretainedValue()

    let isMouseDown = type == .leftMouseDown || type == .rightMouseDown || type == .otherMouseDown
    //let isMouseUp = type == .leftMouseUp || type == .rightMouseUp || type == .otherMouseUp

    print("Callback invoked with event type: \(event.type)")
    
    //print("last active zone:", lastActiveButton)
    
    //if isMouseDown // is true, but lastActiveButton

 
    // New zone determination
    var currentZone: MouseButton?
    if zoneStatus.shared.inLeft {
        currentZone = .left
    } else if zoneStatus.shared.inMid {
        currentZone = .middle
    } else if zoneStatus.shared.inRight {
        currentZone = .right
    }
        

    
    //if (isMouseUp == true && )
        
        
    // Handle moving out of any zones
    if currentZone == nil {
        print("No zone active")
        // Initialize mouse button states to false when starting outside of a zone
        if !leftButtonDown && !middleButtonDown && !rightButtonDown && isMouseDown {
            print("Mouse click initiated outside of any active zone")
                        
            zoneStatus.shared.outside = true
            
            print("is mouse down?", isMouseDown)
            //print("is mouse up?", isMouseUp)
           //print("current zone: ", currentZone)
            //print("zonestatus outside: ", zoneStatus.shared.outside)
            //print("last active zone:", lastActiveButton)
            //print(leftButtonDown, middleButtonDown, rightButtonDown)
            
            
            return Unmanaged.passRetained(event) // Pass through the event without modification
        }

        

        // Generate mouse up events if a button is still down
        if leftButtonDown {
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
            event.type = .leftMouseUp
            leftButtonDown = false
            print("Generated left mouse up")
            lastActiveButton = nil
            return Unmanaged.passRetained(event)
        }
        if middleButtonDown {
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
            event.type = .otherMouseUp
            middleButtonDown = false
            print("Generated middle mouse up")
            lastActiveButton = nil
            return Unmanaged.passRetained(event)
        }
        if rightButtonDown {
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
            event.type = .rightMouseUp
            rightButtonDown = false
            print("Generated right mouse up")
            lastActiveButton = nil
            return Unmanaged.passRetained(event)
        } else if Settings.shared.strictZones {
            print("Ignored click outside zone, strictZones true")
            return nil
        } else {
            print("Passed click outside zone, strictZones false")
            return Unmanaged.passRetained(event)
        }
    }

    
    // Check for zone transition
    if let lastZone = lastActiveButton, lastZone != currentZone, (leftButtonDown || rightButtonDown || middleButtonDown) {
        // Generate mouse up event for the previous zone
        switch lastZone {
        case .left:
            if leftButtonDown {
                event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
                event.type = .leftMouseUp
                leftButtonDown = false
            }
        case .middle:
            if middleButtonDown {
                event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
                event.type = .otherMouseUp
                middleButtonDown = false
            }
        case .right:
            if rightButtonDown {
                event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
                event.type = .rightMouseUp
                rightButtonDown = false
            }
        }
        print("Transition mouse up for \(lastZone)")
        lastActiveButton = currentZone
        return Unmanaged.passRetained(event)
    }

    // Handle mouse down or up events based on current zone
    if let zone = currentZone {
        switch zone {
        case .left:
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
            event.type = isMouseDown ? .leftMouseDown : .leftMouseUp
            leftButtonDown = isMouseDown
        case .middle:
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
            event.type = isMouseDown ? .otherMouseDown : .otherMouseUp
            middleButtonDown = isMouseDown
        case .right:
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
            event.type = isMouseDown ? .rightMouseDown : .rightMouseUp
            rightButtonDown = isMouseDown
        }
        lastActiveButton = zone
    } else {
        lastActiveButton = nil
    }

    print("Event modified to type: \(event.type)")
    return Unmanaged.passRetained(event)
}
