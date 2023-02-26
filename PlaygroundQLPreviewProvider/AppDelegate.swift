//
//  AppDelegate.swift
//  PlaygroundQLPreviewProvider
//
//  Created by Alexandre Podlewski on 26/02/2023.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
