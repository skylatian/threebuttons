//
//  AppDelegate.swift
//  threebuttons
//
//  Created by skylatian on 8/19/24.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var preferencesWindow: NSWindow?
    var clickDetector: EventTapClickDetector?
    var touchManager: BackgroundTouchManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBarItem()
        setupClickDetector()
        touchManager = BackgroundTouchManager()  // Initialize touch manager
    }

    private func setupMenuBarItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = item.button {
            button.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)
            button.action = #selector(togglePreferencesWindow)
            button.target = self
        }
        self.statusItem = item
    }

    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()
        print("Event Tap Click Detector setup complete.")
    }
    


    @objc func togglePreferencesWindow() {
        if preferencesWindow == nil {
            let contentView = ContentView()//.environmentObject(BackgroundTouchManager()) // Ensure it's created and passed here

            
            
            preferencesWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered, defer: false)
            preferencesWindow?.contentView = NSHostingView(rootView: contentView)
            preferencesWindow?.title = "Preferences"
        }
        if let window = preferencesWindow {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
