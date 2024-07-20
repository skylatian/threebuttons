//
//  TrackPadView.swift
//  threebuttons
//
//  Created by skylatian on 7/19/24.
//

import SwiftUI

struct TrackPadView: View {
    private let touchViewSize: CGFloat = 20

    @State var touches: [Touch] = []

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                TouchesView(touches: self.$touches)

                ForEach(self.touches) { touch in
                    Circle()
                        .foregroundColor(touch.normalizedY <= 0.25 ? Color.black : Color.green)
                        .frame(width: self.touchViewSize, height: self.touchViewSize)
                        .offset(
                            x: proxy.size.width * touch.normalizedX - self.touchViewSize / 2.0,
                            y: proxy.size.height * touch.normalizedY - self.touchViewSize / 2.0
                        )
                        .onAppear {
                            if touch.normalizedY <= 0.25 {
                                TouchDataModel.shared.topQuarterTouchesActive = true
                            }
                        }
                        .onDisappear {
                            if touch.normalizedY <= 0.25 {
                                TouchDataModel.shared.topQuarterTouchesActive = false
                            }
                        }
                }
            }
        }
    }
}
