
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
        window.title = "threeButtons"
        //window.level = .normal
        super.init(window: window)
        
        window.contentView = NSHostingView(rootView: MainPreferencesView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func showPreferences() {
        self.showWindow(nil)
        self.window?.makeKeyAndOrderFront(nil)
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
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

struct MainPreferencesView: View {
    var body: some View {
        TabView {
            PreferencesView()
                .tabItem {
                    Label("Preferences", systemImage: "gear")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(minHeight: 610)
        .padding()
    }
}


struct PreferencesView: View {
    var body: some View {
        VStack {
            TrackPadView()
                .background(Color.gray)
                .aspectRatio(1.6, contentMode: .fit)
                .padding(5)
                .frame(maxWidth: .infinity, minHeight: 250, maxHeight: .infinity)
            SettingsColumnView()
                .frame(minWidth: 500)//, minHeight: 150)
        }
    }
}

struct AboutView: View {
//    @State private var isHoveringBuyMeACoffee = false  // State for hover tracking
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .center, spacing: 5) {
                Text("About threeButtons")
                    .font(.title)
                //.padding()
                
                Text("Version: v1.0-beta.64")
                Text("Developed by Skylatian")
                
                HStack(spacing: 0) {  // fix weird spacing between link and text
                    Text("Check out the project on ")
                    Link("GitHub", destination: URL(string: "https://github.com/skylatian/threebuttons/")!)
                    Text(" or ")
                    Link("Sponsor", destination: URL(string: "https://ko-fi.com/skylatian")!)
                }
                
                Text("© 2024")
                
            }
            
            .padding()
            //.frame()//maxWidth: .infinity)
            .background(Color.gray.opacity(0.1)) // Adding a light gray background with slight transparency
            .cornerRadius(10)  // Apply corner radius to round the corners
            .padding(.horizontal, 20)  // Additional horizontal padding for the background

//                Link("Sponsor this project", destination: URL(string: "https://ko-fi.com/skylatian")!)
//                    .padding(5)
//                    .buttonStyle(.plain)
//                    .background(isHoveringBuyMeACoffee ? Color.gray : Color.clear) // Color changes on hover
//                    .cornerRadius(5)
//                    .onHover { hover in
//                        withAnimation {
//                            isHoveringBuyMeACoffee = hover  // Update hover state
//                        }
//                    }

        

        }
    }
}
