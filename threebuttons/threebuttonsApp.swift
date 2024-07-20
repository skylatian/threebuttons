//
//  threebuttonsApp.swift
//  threebuttons
//
//  Created by skylatian on 7/19/24.
//
import SwiftUI
import Foundation

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var eventTap: CFMachPort?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupEventTap()
        print("test")
        // Test if topQuarterTouchesActive is ever true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // Check after 5 seconds
           // print("Top Quarter Touches Active: \(TouchDataModel.shared.topQuarterTouchesActive)")
        }
    }


    private func setupEventTap() {
        let eventsMask = CGEventMask((1 << CGEventType.mouseMoved.rawValue) | (1 << CGEventType.leftMouseDown.rawValue) | (1 << CGEventType.leftMouseUp.rawValue))
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgAnnotatedSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap, // Allows for modification
            eventsOfInterest: CGEventMask(1 << CGEventType.mouseMoved.rawValue),
            callback: { (_, _, event, _) -> Unmanaged<CGEvent>? in
                // Here you can decide whether to modify, block or pass the event
                if TouchDataModel.shared.topQuarterTouchesActive {
                    print("Blocking mouse movement")
                    return nil // Block the event
                }
                // Optionally modify the event
                // event?.setLocation(CGPoint(x: 100, y: 100))
                return Unmanaged.passRetained(event)
            },
            userInfo: nil
        ) else {
            print("Failed to create event tap")
            return
        }


        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        print("Event Tap Enabled")
    }


}
