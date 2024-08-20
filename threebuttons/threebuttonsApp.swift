
//
//  threebuttonsApp.swift
//  threebuttons
//
//  Created by Skylatian on 7/19/24.
//
import SwiftUI
import Foundation
import Cocoa

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

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem? // Ensure it's retained by making it a class property

    var clickDetector: EventTapClickDetector?
    var currentTouches: [Touch] = [] // Store current touch data here

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status item with explicit retention
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let button = statusItem?.button else {
            print("Failed to create status item button.")
            return
        }
        
        //button.image = NSImage(named: NSImage.actionTemplateName)  // Using a default system image
        button.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)

        if button.image == nil {
            print("Icon not found, check the name and asset setup.")
        }
        
        button.action = #selector(togglePreferencesWindow)
        button.target = self  // Ensure the action target is set
        
        setupClickDetector()
    }
    
    @objc func togglePreferencesWindow() {
        // Function to show/hide your preferences window
        if let window = NSApplication.shared.windows.first {
            window.isVisible ? window.close() : window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            print("No window available to toggle.")
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return false
    }

    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()
        print("Event Tap Click Detector setup complete.")
    }
}
