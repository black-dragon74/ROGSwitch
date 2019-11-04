//
//  AppDelegate.swift
//  ROGSwitch
//
//  Created by Nick on 11/4/19.
//  Copyright © 2019 Nick. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    var kbdLightOn: Bool = true

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.toolTip = "Turn keyobard lights on or off"
            button.image = NSImage(named: "rog_insignia")
            button.action = #selector(handleOnOff(_:))
        }
        
        // Turn on the lights
        _ = runShellCommand("/usr/bin/aura", args: ["on"])
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc fileprivate func handleOnOff(_ sender: Any?) {
        if (kbdLightOn) {
            // Turn off
             _ = runShellCommand("/usr/bin/aura", args: ["off"])
        }
        else {
            // Turn on
            _ = runShellCommand("/usr/bin/aura", args: ["on"])
        }

        kbdLightOn = !kbdLightOn
    }
}

