import Cocoa

class MouseButtonState {
    static let shared = MouseButtonState()
    private var actionStates: [CGMouseButton: Bool] = [:]  // Tracks if last action was a press (true) or release (false)
    
    func shouldExecute(button: CGMouseButton, wantsToPress: Bool) -> Bool {
        let lastActionWasPress = actionStates[button] ?? false
        let shouldExecute = lastActionWasPress != wantsToPress
        if shouldExecute {
            actionStates[button] = wantsToPress
        }
        return shouldExecute
    }
}

func simulateClick(button: CGMouseButton, direction: Bool) {
    if MouseButtonState.shared.shouldExecute(button: button, wantsToPress: direction) {
        performClick(button: button, press: direction)
        //print(button, direction)
    }
}

func performClick(button: CGMouseButton, press: Bool) {
    let eventType = press ? button.pressType : button.releaseType
    let currentMouseLocation = NSEvent.mouseLocation
    let screenBounds = NSScreen.main?.frame.size ?? CGSize(width: 1440, height: 900)
    let correctedPosition = CGPoint(x: currentMouseLocation.x, y: screenBounds.height - currentMouseLocation.y)

    if let event = CGEvent(mouseEventSource: nil, mouseType: eventType, mouseCursorPosition: correctedPosition, mouseButton: button) {
        event.post(tap: .cghidEventTap)
        usleep(100000) // delay for 100 milliseconds
        print("Event posted: \(eventType)")
    } else {
        print("Failed to create CGEvent")
    }
}


extension CGMouseButton {
    var pressType: CGEventType {
        switch self {
        case .left:
            return .leftMouseDown
        case .right:
            return .rightMouseDown
        case .center:
            return .otherMouseDown
        }
    }

    var releaseType: CGEventType {
        switch self {
        case .left:
            return .leftMouseUp
        case .right:
            return .rightMouseUp
        case .center:
            return .otherMouseUp
        }
    }
}
