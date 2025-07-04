//
//  appsettings.swift
//  threebuttons
//
//  Created by skylatian on 8/7/24.
//

import Combine
import Foundation
import SwiftUI
import LaunchAtLogin

class Settings: ObservableObject {
    
    static let shared = Settings()

    // zone settings
    @Published var leftZoneStart: CGFloat = 0.0
    @Published var leftZoneEnd: CGFloat = 0.38
    @Published var midZoneStart: CGFloat = 0.38
    @Published var midZoneEnd: CGFloat = 0.62
    @Published var rightZoneStart: CGFloat = 0.62
    @Published var rightZoneEnd: CGFloat = 1.0

    @Published var zoneHeight: CGFloat = 0.15
    
    // toggles
    @Published var strictZones: Bool = false // if true, clicks outside of the left/middle/right zones will be entirely ignored
    @Published var enableLeftZone: Bool = true // allows disabling of left zone
    @Published var enableMidZone: Bool = true // allows disabling of middle zone
    @Published var enableRightZone: Bool = true // allows disabling of right zone
    
    
    
    // usage: settings.shared.strictZones = true
    
    func resetZonesToDefault() {
        leftZoneStart = 0.0
        leftZoneEnd = 0.38
        midZoneStart = 0.38
        midZoneEnd = 0.62
        rightZoneStart = 0.62
        rightZoneEnd = 1.0
    }
    
    
}

// structure to hold zone or sizes
struct ZoneSize {
    var startX: Double
    var startY: Double
    var endX: Double
    var endY: Double
}

// usage: settings.shared.strictZones = true

struct SettingsView: View {
    @ObservedObject private var settings = Settings.shared
    @State private var errorMessage: String? = nil
    
    var body: some View {
        Form {
                Section(header: Text("Left Zone")) {
                    HStack {
                        Text("End: \(settings.leftZoneEnd, specifier: "%.2f")")
                        Slider(value: Binding<CGFloat>(
                            get: { self.settings.leftZoneEnd },
                            set: { newValue in
                                DispatchQueue.main.async {
                                    self.settings.leftZoneEnd = newValue
                                }
                            }
                        ), in: settings.leftZoneStart...settings.midZoneStart, step: 0.02)
                        .frame(width: 150)
                    }
                }
                
                Section(header: Text("Middle Zone")) {
                    HStack {
                        Text("Start: \(settings.midZoneStart, specifier: "%.2f")")
                        Slider(value: Binding<CGFloat>(
                            get: { self.settings.midZoneStart },
                            set: { newValue in
                                DispatchQueue.main.async {
                                    if newValue >= self.settings.midZoneEnd || newValue == 0 {
                                        errorMessage = "Middle zone start cannot be zero or exceed the end!"
                                    } else {
                                        errorMessage = nil
                                        self.settings.midZoneStart = newValue
                                    }
                                }
                            }
                        ), in: settings.leftZoneEnd...settings.midZoneEnd, step: 0.02)
                        .frame(width: 150)
                    }
                    
                    HStack {
                        Text("End: \(settings.midZoneEnd, specifier: "%.2f")")
                        Slider(value: Binding<CGFloat>(
                            get: { self.settings.midZoneEnd },
                            set: { newValue in
                                DispatchQueue.main.async {
                                    if newValue <= self.settings.midZoneStart || newValue == 1 {
                                        errorMessage = "Middle zone end cannot be less than or equal to the start!"
                                    } else {
                                        errorMessage = nil
                                        self.settings.midZoneEnd = newValue
                                    }
                                }
                            }
                        ), in: settings.midZoneStart...settings.rightZoneStart, step: 0.02)
                        .frame(width: 150)
                    }
                }
                
                Section(header: Text("Right Zone")) {
                    HStack {
                        Text("Start: \(settings.rightZoneStart, specifier: "%.2f")")
                        Slider(value: Binding<CGFloat>(
                            get: { self.settings.rightZoneStart },
                            set: { newValue in
                                DispatchQueue.main.async {
                                    self.settings.rightZoneStart = newValue
                                }
                            }
                        ), in: settings.midZoneEnd...settings.rightZoneEnd, step: 0.02)
                        .frame(width: 150)
                    }
                }
            
            
            Button("Restore Defaults") {
                DispatchQueue.main.async { settings.resetZonesToDefault() }
            }
            
            
        }
    }
}

struct toggleView: View {
    
    @ObservedObject var settings = Settings.shared
    
    @State private var optionOne = false
    @State private var optionTwo = false
    @State private var optionThree = false
    @State private var optionFour = false
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                LaunchAtLogin.Toggle()
                Toggle("Strict Zones", isOn: $settings.strictZones)
                    .tooltip("If enabled, clicks outside of the left/middle/right zones will be ignored (only clicks in zones will be recognized")
                Toggle("Enable Left Zone", isOn: $settings.enableLeftZone)
                Toggle("Enable Middle Zone", isOn: $settings.enableMidZone)
                Toggle("Enable Right Zone", isOn: $settings.enableRightZone)
                Toggle("Option Three", isOn: $optionThree)
                Toggle("Option Four", isOn: $optionFour)
                    
            }.padding([.leading, .trailing], 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        
    }
}

struct SettingsColumnView: View {
    var body: some View {
        HStack {
            // Left Column
            VStack {
                Text("Zone Settings").font(.headline).padding([.top], 20).padding([.bottom], 0)
                SettingsView().padding(.all, 10)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // ensure column takes half available width
            .background(Color.gray.opacity(0.1)) // light gray background
            
            // Right Column
            VStack {
                Text("Options").font(.headline).padding([.top], 10)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Hover for details")
                    .font(.subheadline)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 5)
                toggleView()
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // ensure column takes half available width
            .background(Color.gray.opacity(0.1)) // light gray background
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // ensure HStack fills space
    }
}
