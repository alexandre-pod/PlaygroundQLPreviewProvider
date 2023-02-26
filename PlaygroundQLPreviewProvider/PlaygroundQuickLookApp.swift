//
//  PlaygroundQuickLookApp.swift
//  PlaygroundQLPreviewProvider
//
//  Created by Alexandre Podlewski on 26/02/2023.
//

import SwiftUI

@main
struct PlaygroundQuickLookApp: App {

    @NSApplicationDelegateAdaptor
    private var appDelegate: AppDelegate

    var body: some Scene {
        return WindowGroup {
            ContentView()
        }
    }
}
