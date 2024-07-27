//
//  ContentView.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24 from https://gist.github.com/zrzka/224a18517649247a5867fbe65dbd5ae0 / https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad
//

import SwiftUI
import AppKit
import Combine

// Include all the classes and structs you need from the first ContentView here.
// This includes AppKitTouchesView, Touch, TouchesView, and so forth.

struct TrackPadContentView: View {
    var body: some View {
        TrackPadView()
            .background(Color.gray)
            .aspectRatio(1.6, contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



protocol AppKitTouchesViewDelegate: AnyObject {
    // Provides `.touching` touches only.
    func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>)
}

final class AppKitTouchesView: NSView {
    weak var delegate: AppKitTouchesViewDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        // We're interested in `.indirect` touches only.
        allowedTouchTypes = [.indirect]
        // We'd like to receive resting touches as well.
        wantsRestingTouches = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleTouches(with event: NSEvent) {
        // Get all `.touching` touches only (includes `.began`, `.moved` & `.stationary`).
        let touches = event.touches(matching: .touching, in: self)
        // Forward them via delegate.
        delegate?.touchesView(self, didUpdateTouchingTouches: touches)
    }

    override func touchesBegan(with event: NSEvent) {
        handleTouches(with: event)
    }

    override func touchesEnded(with event: NSEvent) {
        handleTouches(with: event)
    }

    override func touchesMoved(with event: NSEvent) {
        handleTouches(with: event)
    }

    override func touchesCancelled(with event: NSEvent) {
        handleTouches(with: event)
    }
}

struct Touch: Identifiable {
    // `Identifiable` -> `id` is required for `ForEach` (see below).
    let id: Int
    // Normalized touch X position on a device (0.0 - 1.0).
    let normalizedX: CGFloat
    // Normalized touch Y position on a device (0.0 - 1.0).
    let normalizedY: CGFloat

    init(_ nsTouch: NSTouch) {
        self.normalizedX = nsTouch.normalizedPosition.x
        // `NSTouch.normalizedPosition.y` is flipped -> 0.0 means bottom. But the
        // `Touch` structure is meants to be used with the SwiftUI -> flip it.
        self.normalizedY = 1.0 - nsTouch.normalizedPosition.y
        self.id = nsTouch.hash
    }
}

struct TouchesView: NSViewRepresentable {
    // Up to date list of touching touches.
    @Binding var touches: [Touch]

    func updateNSView(_ nsView: AppKitTouchesView, context: Context) {
    }

    func makeNSView(context: Context) -> AppKitTouchesView {
        let view = AppKitTouchesView()
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AppKitTouchesViewDelegate {
        let parent: TouchesView

        init(_ view: TouchesView) {
            self.parent = view
        }

        func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>) {
            DispatchQueue.main.async {  // Ensure UI updates are on the main thread
                self.parent.touches = touches.map(Touch.init)
                self.updateZoneStatus(for: self.parent.touches)
                //print(zoneStatus.shared.inLeft, zoneStatus.shared.inMid, zoneStatus.shared.inRight) // works!!
            }
        }

        private func updateZoneStatus(for touches: [Touch]) {
            
            zoneStatus.shared.inLeft = false
            zoneStatus.shared.inMid = false
            zoneStatus.shared.inRight = false

            for touch in touches {
                // print("determinezone for touch in touches")
                let result = ZoneLogic.determineZone(for: touch)
                switch result.zone {
                case .left:
                    zoneStatus.shared.inLeft = true
                case .middle:
                    zoneStatus.shared.inMid = true
                case .right:
                    zoneStatus.shared.inRight = true
                case .outside:
                    break  // Do nothing for outside
                }
            }
            
        }
    }

}

struct TrackPadView: View {

    private let touchViewSize: CGFloat = 20

    @State var touches: [Touch] = []

    var body: some View {
        
        ZStack {
            GeometryReader { proxy in
                TouchesView(touches: self.$touches)

                ForEach(self.touches) { touch in
                    Circle()
                        .foregroundColor(ZoneLogic.determineZone(for: touch).color) // Extract color from the tuple
                        .frame(width: self.touchViewSize, height: self.touchViewSize)
                        .offset(
                            x: proxy.size.width * touch.normalizedX - self.touchViewSize / 2.0,
                            y: proxy.size.height * touch.normalizedY - self.touchViewSize / 2.0
                        )
                }
            }
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
