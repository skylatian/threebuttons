//
//  ContentView.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24 from https://gist.github.com/zrzka/224a18517649247a5867fbe65dbd5ae0 / https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad
//

import SwiftUI
import AppKit
import OpenMultitouchSupport

struct Touch: Identifiable {
    let id: Int
    let normalizedX: CGFloat
    let normalizedY: CGFloat

    init(omsTouchData: OMSTouchData) {
        self.normalizedX = CGFloat(omsTouchData.position.x)
        self.normalizedY = CGFloat(1.0 - omsTouchData.position.y)  // Flip Y coordinate
        self.id = Int(omsTouchData.id)  // Cast from Int32 to Int
    }
}

struct TrackPadView: View {
    @ObservedObject private var settings = Settings.shared
    //@ObservedObject private var touchManager: BackgroundTouchManager
    @ObservedObject private var touchManager = BackgroundTouchManager.shared
    private let touchViewSize: CGFloat = 20

    @State var touches: [Touch] = []

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                // Draw the grey rectangle as the background
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3)) // Light grey background for touchpad

                // Draw zone rectangles based on settings
                drawZoneRect(proxy: proxy, start: settings.leftZoneStart, end: settings.leftZoneEnd, color: .blue)
                drawZoneRect(proxy: proxy, start: settings.midZoneStart, end: settings.midZoneEnd, color: .white)
                drawZoneRect(proxy: proxy, start: settings.rightZoneStart, end: settings.rightZoneEnd, color: .red)


                ForEach(touchManager.touches, id: \.id) { touch in
                    Circle()
                        .foregroundColor(ZoneLogic.determineZone(for: touch).color)
                        .frame(width: touchViewSize, height: touchViewSize)
                        .offset(x: proxy.size.width * touch.normalizedX - touchViewSize / 2.0,
                                y: proxy.size.height * touch.normalizedY - touchViewSize / 2.0)
                }
            }
        }
    }

    private func drawZoneRect(proxy: GeometryProxy, start: CGFloat, end: CGFloat, color: Color) -> some View {
        Rectangle()
            .fill(color.opacity(0.5)) // Semi-transparent colored zone
            .frame(width: proxy.size.width * (end - start), height: proxy.size.height * settings.zoneHeight)
            .offset(x: proxy.size.width * start, y: proxy.size.height - proxy.size.height * settings.zoneHeight)
    }
}


struct ContentView: View {
    var body: some View {
        TrackPadView()
            .background(Color.gray)
            .aspectRatio(1.6, contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        SettingsColumnView()
                       .frame(minWidth: 550, minHeight: 265)
                   
    }
}
