
//
//  threebuttonsApp.swift
//  threebuttons
//
//  Created by Skylatian on 7/19/24.
//

import SwiftUI
import Cocoa

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var preferencesWindow: NSWindow?

    var body: some Scene {
        MenuBarExtra("Menu Item", systemImage: "dot.circle.and.cursorarrow") {
            Button("Toggle Preferences") {
                if preferencesWindow == nil {
                    // Create the window if it does not exist
                    preferencesWindow = createPreferencesWindow()
                }
                toggleWindow(preferencesWindow)
            }
        }
    }

    private func createPreferencesWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: PreferencesView())
        window.title = "Preferences"
        return window
    }

    private func toggleWindow(_ window: NSWindow?) {
        guard let window = window else { return }
        if window.isVisible {
            window.orderOut(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}


struct PreferencesView: View { // this is the correct overall view for the preferences window
    var body: some View {
        TrackPadView()
            .background(Color.gray)
            .aspectRatio(1.6, contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        SettingsColumnView()
                       .frame(minWidth: 600, minHeight: 265)
    }
}
