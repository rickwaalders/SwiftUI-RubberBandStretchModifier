//
//  ContentView.swift
//  SwiftUI-RubberBandStretchModifier
//
//  Created by Rick Waalders on 20/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Circle()
        .frame(width: 100, height: 100)
        .foregroundColor(.green)
        .rubberBandStretchEffect(scalingFactor: 550.0, stretchFactor: 0.3)
    }
}

#Preview {
    ContentView()
}
