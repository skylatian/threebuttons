
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

    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}

//@main
//struct MyApp: App { // https://stackoverflow.com/a/75392218
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    var body: some Scene {
//        // -- no WindowGroup required --
//        // -- no AppDelegate needed --
//        MenuBarExtra {
//            Text("Hello Status Bar Menu!")
//            //MyCustomSubmenu()
//            Divider()
//            Button("Quit") { NSApp.terminate(nil) }
//        } label: {
//            Image(systemName: "bolt.fill")
//        }
//    }
//}
