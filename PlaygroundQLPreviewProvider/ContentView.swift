//
//  ContentView.swift
//  PlaygroundQLPreviewProvider
//
//  Created by Alexandre Podlewski on 26/02/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("onboarding.title")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            Text("onboarding.message")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(width: 400, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
