//
//  BackgroundTouchManager.swift .swift
//  threebuttons
//
//  Created by skylatian on 8/19/24.
//

import AppKit
import OpenMultitouchSupport
import Combine

class BackgroundTouchManager: NSObject, ObservableObject {
    static let shared = BackgroundTouchManager()  // Singleton instance
    private var cancellables = Set<AnyCancellable>()
    @Published var touches: [Touch] = []  // This will hold the current touches and publish updates

    override init() {
        super.init()
        setupTouchDataPublisher()
    }

    private func setupTouchDataPublisher() {
        let touchDataPublisher = OMSManager.shared.touchDataPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        touchDataPublisher
            .sink { [weak self] touchData in
                self?.handleTouchData(touchData)
            }
            .store(in: &cancellables)

        OMSManager.shared.startListening()
    }

    private func handleTouchData(_ touchData: [OMSTouchData]) {
        self.touches = touchData.map { Touch(omsTouchData: $0) }
        updateZoneStatus(for: self.touches)
    }

    private func updateZoneStatus(for touches: [Touch]) {
        zoneStatus.shared.inLeft = false
        zoneStatus.shared.inMid = false
        zoneStatus.shared.inRight = false

        for touch in touches {
            let result = ZoneLogic.determineZone(for: touch)
            switch result.zone {
            case .left:
                zoneStatus.shared.inLeft = true
            case .middle:
                zoneStatus.shared.inMid = true
            case .right:
                zoneStatus.shared.inRight = true
            case .outside:
                continue  // Do nothing for outside
            }
        }
    }

    deinit {
        OMSManager.shared.stopListening()
    }
}
