//
//  ContentView.swift
//  threebuttons
//
//  Created by skylatian on 7/19/24.
//
// https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad

import SwiftUI
import AppKit

protocol AppKitTouchesViewDelegate: AnyObject {
    func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>)
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
        delegate?.touchesView(self, didUpdateTouchingTouches: event.touches(matching: .touching, in: self))
    }

    override func touchesMoved(with event: NSEvent) {
        delegate?.touchesView(self, didUpdateTouchingTouches: event.touches(matching: .touching, in: self))
    }

    override func touchesEnded(with event: NSEvent) {
        delegate?.touchesView(self, didUpdateTouchingTouches: event.touches(matching: .touching, in: self))
    }

    override func touchesCancelled(with event: NSEvent) {
        delegate?.touchesView(self, didUpdateTouchingTouches: event.touches(matching: .touching, in: self))
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
        var parent: TouchesView

        init(_ parent: TouchesView) {
            self.parent = parent
        }

        func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>) {
            let mappedTouches = touches.map(Touch.init)
            parent.touches = mappedTouches
            for touch in mappedTouches {
                if touch.normalizedY <= 0.15 {
                    let x = touch.normalizedX
                    if x < 0.4 {
                        simulateClick(type: .left)
                        print("left")
                    } else if x >= 0.4 && x <= 0.6 {
                        simulateClick(type: .middle)
                        print("middle")
                    } else if x > 0.6 {
                        simulateClick(type: .right)
                        print("right")
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
        if touch.normalizedY <= 0.15 {
            if touch.normalizedX < 0.4 {
                return Color.blue  // Left region
            } else if touch.normalizedX >= 0.4 && touch.normalizedX <= 0.6 {
                return Color.white // Middle region
            } else {
                return Color.red   // Right region
            }
        } else {
            return Color.green // Outside the top 15% region
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
