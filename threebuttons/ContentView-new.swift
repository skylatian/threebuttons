//
//  ContentView.swift
//  threebuttons
//
//  Created by skylatian on 7/26/24 from https://gist.github.com/zrzka/224a18517649247a5867fbe65dbd5ae0 / https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad
//

import SwiftUI
import AppKit
import Combine
import OpenMultitouchSupport

protocol AppKitTouchesViewDelegate: AnyObject {
    func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: [Touch])
}

final class AppKitTouchesView: NSView {
    weak var delegate: AppKitTouchesViewDelegate?
    private var cancellables = Set<AnyCancellable>()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let manager = OMSManager.shared
        manager.touchDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] touchData in
                guard let strongSelf = self else { return }
                let touches = touchData.map { Touch(omsTouchData: $0) }
                strongSelf.delegate?.touchesView(strongSelf, didUpdateTouchingTouches: touches)
            }
            .store(in: &cancellables)
        manager.startListening()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        OMSManager.shared.stopListening()
    }
}

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

        func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: [Touch]) {
            DispatchQueue.main.async {  // Ensure UI updates are on the main thread
                self.parent.touches = touches
                self.updateZoneStatus(for: self.parent.touches)
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
