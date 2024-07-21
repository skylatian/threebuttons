//
//  ContentView.swift
//  threebuttons
//
//  Created by skylatian on 7/19/24.
//  https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad

import SwiftUI
import AppKit

protocol AppKitTouchesViewDelegate: AnyObject {
    func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>, pressure: CGFloat)
}

enum ClickType {
    case left
    case middle
    case right
}

final class AppKitTouchesView: NSView {
    weak var delegate: AppKitTouchesViewDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        allowedTouchTypes = [.indirect]
        wantsRestingTouches = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(with event: NSEvent) {
        processTouches(event: event)
    }

    override func touchesMoved(with event: NSEvent) {
        processTouches(event: event)
    }

    override func touchesEnded(with event: NSEvent) {
        processTouches(event: event)
    }

    override func touchesCancelled(with event: NSEvent) {
        processTouches(event: event)
    }

    override func pressureChange(with event: NSEvent) {
        super.pressureChange(with: event)
        if event.type == .pressure {
            let touches = event.touches(matching: .touching, in: self)
            delegate?.touchesView(self, didUpdateTouchingTouches: touches, pressure: CGFloat(event.pressure))
        }
    }

    private func processTouches(event: NSEvent) {
        let touches = event.touches(matching: .touching, in: self)
        // Only report pressure when it's meaningful
        let pressure: CGFloat = CGFloat(event.type == .pressure ? event.pressure : 0.0)
        delegate?.touchesView(self, didUpdateTouchingTouches: touches, pressure: pressure)
    }
}

struct TouchZoneManager {
    var normalizedX: CGFloat
    var normalizedY: CGFloat

    enum Zone {
        case left
        case middle
        case right
        case outside
    }

    func determineZone() -> Zone {
        guard normalizedY >= 0.85 else {
            return .outside
        }
        if normalizedX < 0.4 {
            return .left
        } else if normalizedX >= 0.4 && normalizedX <= 0.6 {
            return .middle
        } else {
            return .right
        }
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
        // `Touch` structure is meant to be used with the SwiftUI -> flip it.
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
        var parent: TouchesView

        init(_ parent: TouchesView) {
            self.parent = parent
        }

        func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>, pressure: CGFloat) {
            let mappedTouches = touches.map(Touch.init)
            DispatchQueue.main.async {
                self.parent.touches = mappedTouches  // Update the touches on the main thread
            }

            // Define your pressure threshold here
            let pressureThreshold: CGFloat = 0.5  // Example threshold, adjust based on your needs
            
            print(pressure)
            print(touches)

            if pressure > pressureThreshold {
                for touch in mappedTouches {
                    let zoneManager = TouchZoneManager(normalizedX: touch.normalizedX, normalizedY: touch.normalizedY)
                    switch zoneManager.determineZone() {
                    case .left:
                        simulateClick(type: .left)
                        print("Left click simulated")
                    case .middle:
                        simulateClick(type: .middle)
                        print("Middle click simulated")
                    case .right:
                        simulateClick(type: .right)
                        print("Right click simulated")
                    case .outside:
                        print("Outside of designated zones")
                    }
                }
            }
        }

        private func simulateClick(type: ClickType) {
            let currentMouseLocation = NSEvent.mouseLocation
            let screenBounds = NSScreen.main?.frame.size ?? CGSize(width: 1440, height: 900) // Default screen size if screen detection fails
            let correctedPosition = CGPoint(x: currentMouseLocation.x, y: screenBounds.height - currentMouseLocation.y) // Correct for flipped Y coordinate

            let eventSource = CGEventSource(stateID: .combinedSessionState)
            let location = CGEventTapLocation.cghidEventTap
            var mouseType: CGEventType

            switch type {
            case .left:
                mouseType = .leftMouseDown
            case .middle:
                mouseType = .otherMouseDown
            case .right:
                mouseType = .rightMouseDown
            }

            if let event = CGEvent(mouseEventSource: eventSource, mouseType: mouseType, mouseCursorPosition: correctedPosition, mouseButton: .left) {
                event.post(tap: location)
                // Add a mouse up event to complete the click
                let mouseUpType: CGEventType = (type == .middle) ? .otherMouseUp : (type == .left ? .leftMouseUp : .rightMouseUp)
                if let eventUp = CGEvent(mouseEventSource: eventSource, mouseType: mouseUpType, mouseCursorPosition: correctedPosition, mouseButton: .left) {
                    eventUp.post(tap: location)
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
        let zoneManager = TouchZoneManager(normalizedX: touch.normalizedX, normalizedY: touch.normalizedY)
        switch zoneManager.determineZone() {
        case .left:
            return .blue
        case .middle:
            return .white
        case .right:
            return .red
        case .outside:
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
