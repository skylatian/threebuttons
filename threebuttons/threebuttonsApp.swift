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


class AppDelegate: NSObject, NSApplicationDelegate, AppKitTouchesHandlerDelegate {
    var clickDetector: EventTapClickDetector?
    var currentTouches: [Touch] = [] // Store current touch data here

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupClickDetector()
        setupTouchHandling()
    }

    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()

        print("Event Tap Click Detector setup complete.")
    }

    private func setupTouchHandling() {
        // Assuming your touch handler view is initialized somewhere you can set delegate
        let touchHandlerView = AppKitTouchesHandler()
        touchHandlerView.delegate = self // Set AppDelegate as the delegate
    }

    // Delegate method from your touch handling system
    func TouchInputManager(_ view: AppKitTouchesHandler, didUpdateTouchingTouches touches: Set<NSTouch>) {
        print("map touches")
        self.currentTouches = touches.map(Touch.init) // Convert NSTouch to Touch and update
    }
    
    
    
}
