//
//  StandupTimerApp.swift
//  StandupTimer
//
//  Created by Mohsin Khawas on 6/5/25.
//

import SwiftUI

#if os(macOS)
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var windowTimer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        windowTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            if let window = NSApplication.shared.windows.first {
                window.level = .statusBar
                window.backgroundColor = .white
                window.isOpaque = true
                window.hasShadow = true
                window.isMovableByWindowBackground = true
                window.standardWindowButton(.closeButton)?.isHidden = false
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                window.hidesOnDeactivate = false
            }
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        windowTimer?.invalidate()
    }
}
#endif

@main
struct StandupTimerApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(width: 200, height: 120)
            #endif
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 200, height: 120)
        .windowResizability(.contentSize)
        #endif
    }
}
