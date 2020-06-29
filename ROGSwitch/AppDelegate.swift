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
    
    private var kbdLightOn: Bool = true
    private var brightnessLevel: Int = 3
    
    private let rogAuraCore = "/usr/local/bin/macRogAuraCore"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.toolTip = "Turn keyobard lights on or off"
            button.image = NSImage(named: "rog_insignia")
        }
        
        buildMenu()
        
        // Turn on the keyboard lights on start
        runShellCommand(rogAuraCore, args: ["brightness", "\(brightnessLevel)"])
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    fileprivate func buildMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Turn lights on", action: #selector(handleKbdOn), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Turn lights off", action: #selector(handleKbdOff), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Increase brightness", action: #selector(handleBrightnessUp), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Decrease Brightness", action: #selector(handleBrightnessDown), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Turn lights red", action: #selector(handleRed), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Turn lights green", action: #selector(handleGreen), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Turn lights magenta", action: #selector(handleMagenta), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Turn lights gold", action: #selector(handleGold), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Rainbow mode", action: #selector(handleRainbow), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Color cycle mode", action: #selector(handleColorCycle), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Multicolor breathing mode", action: #selector(handleBreathingMode), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit ROGSwitch", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        statusItem.menu = menu
    }
    
    @objc fileprivate func handleKbdOn() {
        if (kbdLightOn) {
            return
        }
        
        // Otherwise, turn on the keyboard lights full brightness
        runShellCommand(rogAuraCore, args: ["on"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleKbdOff() {
        if (!kbdLightOn) {
            return
        }
        
        // Otherwise, turn off kbd lights
        runShellCommand(rogAuraCore, args: ["off"])
        brightnessLevel = 0
        kbdLightOn = false
    }
    
    @objc fileprivate func handleBrightnessUp() {
        if (brightnessLevel >= 3) {
            return
        }
        
        brightnessLevel += 1
        runShellCommand(rogAuraCore, args: ["brightness", "\(brightnessLevel)"])
        kbdLightOn = true
    }
    
    @objc fileprivate func handleBrightnessDown() {
        if (brightnessLevel <= 0) {
            return
        }
        
        brightnessLevel -= 1
        runShellCommand(rogAuraCore, args: ["brightness", "\(brightnessLevel)"])
        kbdLightOn = brightnessLevel != 0
    }
    
    @objc fileprivate func handleRed() {
        runShellCommand(rogAuraCore, args: ["red"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleGreen() {
        runShellCommand(rogAuraCore, args: ["green"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleMagenta() {
        runShellCommand(rogAuraCore, args: ["magenta"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleGold() {
        runShellCommand(rogAuraCore, args: ["gold"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleRainbow() {
        runShellCommand(rogAuraCore, args: ["rainbow"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleColorCycle() {
        runShellCommand(rogAuraCore, args: ["single_colorcycle", "1"])
        brightnessLevel = 3
        kbdLightOn = true
    }
    
    @objc fileprivate func handleBreathingMode() {
        runShellCommand(rogAuraCore, args: ["multi_breathing", "ff0000", "00ff00", "0000ff", "00ffff", "2"])
        brightnessLevel = 3
        kbdLightOn = true
    }
}

