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
    var onClick: ((Bool, CGPoint) -> Void)?

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

private func myEventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let clickDetector = Unmanaged<EventTapClickDetector>.fromOpaque(refcon!).takeUnretainedValue()

    // Determine if the event is a mouse down or up
    let isMouseDown = type == .leftMouseDown || type == .rightMouseDown || type == .otherMouseDown
    let isMouseUp = type == .leftMouseUp || type == .rightMouseUp || type == .otherMouseUp

    // Check conditions to suppress the original event
    if !(zoneStatus.shared.inLeft || zoneStatus.shared.inMid || zoneStatus.shared.inRight) {
        // Suppress original mouse event
        return nil
    }

    // Handle mouse down or up events
    if isMouseDown || isMouseUp {
        DispatchQueue.main.async {
            // Execute callback for allowed clicks
            clickDetector.onClick?(isMouseDown, event.location)
        }
        // Allow the original event to proceed
        return Unmanaged.passRetained(event)
    }

    // For other types of events, just pass them through
    return Unmanaged.passRetained(event)
}


