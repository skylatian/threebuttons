//
//  ContentView.swift
//  threebuttons
//
//  Created by skylatian on 7/19/24.
//
// https://stackoverflow.com/questions/61834910/swiftui-detect-finger-position-on-mac-trackpad

import SwiftUI

struct ContentView: View {
    var body: some View {
        TrackPadView()
            .background(Color.gray)
            .aspectRatio(1.6, contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
