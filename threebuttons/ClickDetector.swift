//
//  ClickDetector.swift
//  threebuttons
//
//  Created by skylatian on 7/21/24.
//

import Cocoa
import CoreGraphics

enum ClickType: String {
    case leftDown = "Left Mouse Down"
    case middleDown = "Middle Mouse Down"
    case rightDown = "Right Mouse Down"
    case leftUp = "Left Mouse Up"
    case middleUp = "Middle Mouse Up"
    case rightUp = "Right Mouse Up"
}

class EventTapClickDetector {
    var eventTap: CFMachPort?
    var onClick: ((ClickType, CGPoint) -> Void)?

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
                                     userInfo: Unmanaged.passUnretained(self).toOpaque())

        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            print("set up event tap")
        } else {
            print("Failed to create event tap")
        }
    }

    private func stopEventTap() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0), .commonModes)
        }
    }
}

private func myEventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let clickDetector = Unmanaged<EventTapClickDetector>.fromOpaque(refcon!).takeUnretainedValue()
    let ClickType: ClickType?

    switch type {
    case .leftMouseDown:
        ClickType = .leftDown
    case .rightMouseDown:
        ClickType = .rightDown
    case .otherMouseDown:
        ClickType = .middleDown
    case .leftMouseUp:
        ClickType = .leftUp
    case .rightMouseUp:
        ClickType = .rightUp
    case .otherMouseUp:
        ClickType = .middleUp
    default:
        return Unmanaged.passRetained(event)
    }

    if let ClickType = ClickType {
        let location = event.location
        DispatchQueue.main.async {
            clickDetector.onClick?(ClickType, location) // callback
            //print("\(ClickType.rawValue) at \(event.location)")
        }
    }
    
    return Unmanaged.passRetained(event)
}

// Initialize the detector
//let detector = EventTapClickDetector()
