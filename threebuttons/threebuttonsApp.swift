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
        let mouseEvents = CGEventType.mouseMoved.rawValue | CGEventType.leftMouseDown.rawValue | CGEventType.leftMouseUp.rawValue
        let eventsMask = CGEventMask(1 << mouseEvents)

        guard let eventTap = CGEvent.tapCreate(tap: .cgAnnotatedSessionEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: eventsMask, callback: { (_, _, event, _) -> Unmanaged<CGEvent>? in
            if TouchDataModel.shared.topQuarterTouchesActive {
                print("blocked?")
                return nil
            }
            return Unmanaged.passRetained(event)
        }, userInfo: nil) else {
            print("Failed to create event tap")
            return
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }

}
