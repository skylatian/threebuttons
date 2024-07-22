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
    var clickDetector: EventTapClickDetector?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupClickDetector()
    }

    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()
        clickDetector?.onClick = { clickType, location in
            ClickHandler.handle(clickType: clickType, location: location)
        }
        print("Event Tap Click Detector setup complete.")
    }
}
