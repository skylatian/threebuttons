
//  https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad

import SwiftUI
import AppKit

protocol AppKitTouchesHandlerDelegate: AnyObject {
    func TouchInputManager(_ view: AppKitTouchesHandler, didUpdateTouchingTouches touches: Set<NSTouch>)
}

//enum ClickType {
  //  case left
// case middle
//    case right
//}

final class AppKitTouchesHandler: NSView {
    weak var delegate: AppKitTouchesHandlerDelegate?

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

    private func processTouches(event: NSEvent) {
        let touches = event.touches(matching: .touching, in: self)
        //print("touches: \(touches)")
        delegate?.TouchInputManager(self, didUpdateTouchingTouches: touches)
    }
}

struct TouchZoneManager {
    var touches: [Touch]

    enum Zone {
        case left, middle, right, outside
    }

    // New method to check the presence of fingers in zones
    func isFingerInZone() -> (left: Bool, middle: Bool, right: Bool) {
        // print("isfingerinzone") // this runs!
        var isLeftZone = false
        var isMiddleZone = false
        var isRightZone = false
        
        
        
        print("zoning...")

        for touch in touches {
            print("touching...")
            print(touch.normalizedX, touch.normalizedY)
            switch determineZone(normalizedX: touch.normalizedX, normalizedY: touch.normalizedY) {
            case .left:
                isLeftZone = true
            case .middle:
                isMiddleZone = true
            case .right:
                isRightZone = true
            case .outside:
                continue
            }
        }
        // Update the global zone status tracker
        //ZoneStatusTracker.shared.isLeftZoneActive = isLeftZone
        //ZoneStatusTracker.shared.isMiddleZoneActive = isMiddleZone
        //ZoneStatusTracker.shared.isRightZoneActive = isRightZone
        print("global update")
        print(isLeftZone, isMiddleZone, isRightZone)
        
        return (isLeftZone, isMiddleZone, isRightZone)
    }

    // Updated method to determine the zone based on coordinates
    func determineZone(normalizedX: CGFloat, normalizedY: CGFloat) -> Zone {
        // print("determineZone") // woohoo! this runs now!
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
} // determines where a touch was performed

struct Touch: Identifiable {
    
    // represents a single touch event on the trackpad
    
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
        // print(self.normalizedX,self.normalizedY)
    }
} // represents a single touch event on the trackpad

struct TouchInputManager: NSViewRepresentable {
    // Up to date list of touching touches.
    @Binding var touches: [Touch]

    func updateNSView(_ nsView: AppKitTouchesHandler, context: Context) {
    }

    func makeNSView(context: Context) -> AppKitTouchesHandler {
        let view = AppKitTouchesHandler()
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AppKitTouchesHandlerDelegate {
        var parent: TouchInputManager

        init(_ parent: TouchInputManager) {
            self.parent = parent
        }

        func TouchInputManager(_ view: AppKitTouchesHandler, didUpdateTouchingTouches touches: Set<NSTouch>) {
            let mappedTouches = touches.map(Touch.init)
            DispatchQueue.main.async {
                self.parent.touches = mappedTouches  // Update the touches on the main thread
            }
            
        }

    }
    
}

// Singleton to track the status of each zone
class ZoneStatusTracker {
    static let shared = ZoneStatusTracker()
    

    private init() {}

    var isLeftZoneActive: Bool = false
    var isMiddleZoneActive: Bool = false
    var isRightZoneActive: Bool = false
}
