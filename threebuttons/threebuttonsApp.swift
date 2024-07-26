//
//  threebuttonsApp.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24 from https://gist.github.com/zrzka/224a18517649247a5867fbe65dbd5ae0 / https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad
//

import SwiftUI
import Foundation

@main

struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var sharedZoneStatus = zoneStatus() // initialze the shared zonestatus

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(zoneStatus()) // required to access zoneStatus app-wide
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("nyoom")
        
    }

}
