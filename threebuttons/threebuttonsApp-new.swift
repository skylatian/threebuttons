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
        
        print("nyoom")
        
    }
    
    private func setupClickDetector() {
        clickDetector = EventTapClickDetector()
        clickDetector?.onClick = { clickType, location in
            ClickHandler.handle(clickType: clickType, location: location)
            //print("\(clickType.rawValue) at \(location)")
        }
        print("Event Tap Click Detector setup complete.")
    }

}
