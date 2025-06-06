//
//  StandupTimerApp.swift
//  StandupTimer
//
//  Created by Mohsin Khawas on 6/5/25.
//

import SwiftUI
import AppKit

@main
struct StandupTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 200, height: 150)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.level = NSWindow.Level(rawValue: NSWindow.Level.floating.rawValue + 1)
            window.backgroundColor = .white
            window.isOpaque = true
            window.hasShadow = true
            window.isMovableByWindowBackground = true
            window.standardWindowButton(.closeButton)?.isHidden = false
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            
            // Set window to be visible on all spaces and stay on top
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            window.hidesOnDeactivate = false
        }
    }
}
