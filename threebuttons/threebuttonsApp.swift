
//
//  threebuttonsApp.swift
//  threebuttons
//
//  Created by Skylatian on 7/19/24.
//
import SwiftUI
import Foundation

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().frame(minWidth: 500, minHeight: 300)
            SettingsColumnView()
                .frame(minWidth: 500, minHeight: 265)
            
        }
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var clickDetector: EventTapClickDetector?
    var currentTouches: [Touch] = [] // Store current touch data here

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupClickDetector()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }

    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()

        print("Event Tap Click Detector setup complete.")
    }
    
    
}
