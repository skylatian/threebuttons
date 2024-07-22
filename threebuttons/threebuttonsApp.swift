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
    var clickDetector: EventTapClickDetector?

    func applicationDidFinishLaunching(_ notification: Notification) {
        clickDetector = EventTapClickDetector()
    
        print("test")
        }
    }
