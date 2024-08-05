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
    // Set the mouse button type
    switch newButtonType {
    case .left:
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
    case .right:
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
    case .middle:
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
    }

    event.type = newEventType // Set the new event type - unsure if needed

    return event
}

import Cocoa

// Assuming these are global or class-level variables to track the button states
var leftButtonDown = false
var rightButtonDown = false
var middleButtonDown = false

private func myEventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    // Determine if the event is a mouse down or up
    let isMouseDown = type == .leftMouseDown || type == .rightMouseDown || type == .otherMouseDown

    print("Callback invoked with event type: \(event.type)")

    // Check if no zone is active
    if !(zoneStatus.shared.inLeft || zoneStatus.shared.inMid || zoneStatus.shared.inRight) {
        print("No zone active")
        // Generate mouse up events if needed
        if leftButtonDown {
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
            event.type = .leftMouseUp
            leftButtonDown = false
            print("Generated left mouse up")
        }
        if middleButtonDown {
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
            event.type = .otherMouseUp
            middleButtonDown = false
            print("Generated middle mouse up")
        }
        if rightButtonDown {
            event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
            event.type = .rightMouseUp
            rightButtonDown = false
            print("Generated right mouse up")
        }
        return Unmanaged.passRetained(event)
    }

    // Handle events based on specific zones
    if zoneStatus.shared.inLeft {
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.left.rawValue))
        event.type = isMouseDown ? .leftMouseDown : .leftMouseUp
        leftButtonDown = isMouseDown
    } else if zoneStatus.shared.inMid {
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.center.rawValue))
        event.type = isMouseDown ? .otherMouseDown : .otherMouseUp
        middleButtonDown = isMouseDown
    } else if zoneStatus.shared.inRight {
        event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
        event.type = isMouseDown ? .rightMouseDown : .rightMouseUp
        rightButtonDown = isMouseDown
    }

    print("Event modified to type: \(event.type)")
    return Unmanaged.passRetained(event)
}
