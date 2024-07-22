//
//  IOHIDmanager.swift
//  threebuttons
//
//  Created by skylatian on 7/21/24.
//

import Foundation
import IOKit
import IOKit.hid

class TrackpadMonitor {
    var hidManager: IOHIDManager?

    init() {
        setupTrackpadMonitoring()
    }

    func setupTrackpadMonitoring() {
        hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
               let matchDictionary: [String: Any] = [kIOHIDDeviceUsagePageKey: kHIDPage_Digitizer, // Use the Digitizer page for touchpad
                                                     kIOHIDDeviceUsageKey: kHIDUsage_Dig_TouchPad]  // Specifically match touchpad usage
               
        if let hidManager = hidManager {
            IOHIDManagerSetDeviceMatching(hidManager, matchDictionary as CFDictionary)

            let context = Unmanaged.passUnretained(self).toOpaque()
            IOHIDManagerRegisterInputValueCallback(hidManager, { inContext, inResult, inSender, inIOHIDValueRef in
                let mySelf = Unmanaged<TrackpadMonitor>.fromOpaque(inContext!).takeUnretainedValue()
                mySelf.handleTrackpadInput(inIOHIDValueRef: inIOHIDValueRef)
            }, context)

            IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
            print("created HID manager")
        } else {
            print("Failed to create HID Manager")
        }
    }

    func handleTrackpadInput(inIOHIDValueRef: IOHIDValue) {
           // Obtain the element representing the data we are interested in
           let element = IOHIDValueGetElement(inIOHIDValueRef)
           let elementType = IOHIDElementGetType(element)
           let elementUsage = IOHIDElementGetUsage(element)
           let elementUsagePage = IOHIDElementGetUsagePage(element)
           
           // Log the details about the element
           let elementTypeName = String(describing: elementType)
           let elementUsageName = String(describing: elementUsage)
           let elementUsagePageName = String(describing: elementUsagePage)
           
           print("Element type: \(elementTypeName), Usage: \(elementUsageName), Usage Page: \(elementUsagePageName)")
       }
}

// Use the monitor
let trackpadMonitor = TrackpadMonitor()
