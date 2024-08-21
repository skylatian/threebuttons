
//
//  threebuttonsApp.swift
//  threebuttons
//
//  Created by skylatian on 7/19/24.
//

import SwiftUI
import Cocoa

class PreferencesWindowController: NSWindowController {
    static let shared = PreferencesWindowController(window: nil)
    
    override init(window: NSWindow?) {
        let contentRect = NSRect()//x: 0, y: 0, width: 800, height: 600)
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        let backing: NSWindow.BackingStoreType = .buffered
        
        let window = NSWindow(contentRect: contentRect, styleMask: style, backing: backing, defer: false)
        window.center()
        window.isReleasedWhenClosed = false  // Prevents the window from being destroyed
        window.title = "Preferences"
        super.init(window: window)
        
        window.contentView = NSHostingView(rootView: PreferencesView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func showPreferences() {
        self.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Menu Item", systemImage: "dot.circle.and.cursorarrow") {
            Button("Preferences") {
                PreferencesWindowController.shared.showPreferences()
            }
        }
    }
}

struct PreferencesView: View {
    var body: some View {
        VStack {
            TrackPadView()
                .background(Color.gray)
                .aspectRatio(1.6, contentMode: .fit)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            SettingsColumnView()
                .frame(minWidth: 600, minHeight: 265)
        }
    }
}
