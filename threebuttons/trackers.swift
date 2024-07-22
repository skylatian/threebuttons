//
//  trackers.swift
//  threebuttons
//
//  Created by skylatian on 7/21/24.
//

import Foundation
import CoreGraphics

class CursorPosition {
    
    // access this class by:
    // import UIKit
    
    // To set the cursor position
    // CursorPosition.shared.setPosition(CGPoint(x: 100, y: 200))

    // To get the cursor position
    // let currentPosition = CursorPosition.shared.getPosition()
    // print("Current cursor position: \(currentPosition)")

    
    static let shared = CursorPosition()

    private init() {}

    private var position: CGPoint = .zero

    func setPosition(_ newPosition: CGPoint) {
        self.position = newPosition
    }

    func getPosition() -> CGPoint {
        return self.position
    }
}
