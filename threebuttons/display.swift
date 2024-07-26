//
//  display.swift
//  threebuttons
//
//  Created by skylatian on 7/21/24.
//

import Foundation
import SwiftUI
import AppKit

struct TrackPadView: View {
    private let touchViewSize: CGFloat = 20
    @State var touches: [Touch] = []
    
    var body: some View {
        
        //
        
        ZStack {
            GeometryReader { proxy in
                TouchInputManager(touches: self.$touches)
                
                ForEach(self.touches) { touch in
                    
                    // creates the circles
                    
                    Circle()
                        .foregroundColor(regionColor(for: touch))
                        .frame(width: self.touchViewSize, height: self.touchViewSize)
                        .offset(
                            x: proxy.size.width * touch.normalizedX - self.touchViewSize / 2.0,
                            y: proxy.size.height * touch.normalizedY - self.touchViewSize / 2.0
                        )
                }
            }
        }
    }
    
    private func regionColor(for touch: Touch) -> Color {
        
        // sets the color for each dot
        
        let zoneManager = TouchZoneManager(touches: touches)
        
        switch zoneManager.determineZone(normalizedX: touch.normalizedX, normalizedY: touch.normalizedY) {
            
            
            
        case .left:
            //          ZoneStatusTracker.shared.isLeftZoneActive = true
            return .blue
        case .middle:
            //          ZoneStatusTracker.shared.isMiddleZoneActive = true
            return .white
        case .right:
            //          ZoneStatusTracker.shared.isRightZoneActive = true
            return .red
        case .outside:
            //            ZoneStatusTracker.shared.isLeftZoneActive = false
            //            ZoneStatusTracker.shared.isMiddleZoneActive = false
            //            ZoneStatusTracker.shared.isRightZoneActive = false
            return .green
        }
    }
}




struct ContentView: View {
    var body: some View {
        TrackPadView()
            .background(Color.gray)
            .aspectRatio(1.6, contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

