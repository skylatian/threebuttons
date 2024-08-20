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
        //setupMenuBarItem()
        setupClickDetector()
        touchManager = BackgroundTouchManager()  // Initialize touch manager
        print("launch, baby!")
    }

    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()
        print("Event Tap Click Detector setup complete.")
    }


}
