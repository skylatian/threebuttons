//
//  appsettings.swift
//  threebuttons
//
//  Created by skylatian on 8/7/24.
//

import Combine

class settings: ObservableObject {
    static let shared = settings()

    @Published var strictZones: Bool = true // if true, clicks outside of the left/middle/right zones will be entirely ignored

    private init() { }
}

// usage: settings.shared.strictZones = true
