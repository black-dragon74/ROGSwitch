//
//  AppDelegate.swift
//  ROGSwitch
//
//  Created by Nick on 11/4/19.
//  Copyright © 2019 Nick. All rights reserved.
//

import Cocoa

enum ROGSwitchColors: Int, Codable {
    case red = 1
    case green
    case magenta
    case gold
    case rainbow
    case colorCycle
    case breathing
}

struct ROGSwitchState: Codable {
    var isIlluminated: Bool
//    var luxLevel: Int
    var currentColor: ROGSwitchColors
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private var appState = ROGSwitchState(isIlluminated: true, currentColor: .red)
    
    private let DEFAULT_KEY = "ROGSwitchState"
    private let rogAuraCore = "/usr/local/bin/macRogAuraCore"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.toolTip = "Manage your ROG AURA keyboard"
            button.image = NSImage(named: "rog_insignia")
        }
        
        // Now check if the rog aura core exists and is installed in the system
        let auraCheck = runShellCommand("/usr/bin/find", args: ["/usr/local/bin", "-name", "macRogAuraCore"])!
        if (!auraCheck.isEqualTo(other: rogAuraCore)) {
            buildErrorMenu()
        } else {
            buildMenu()
            
            // Read app's laste state from the DB
            readValuesFromDB()
            
            // Now restore the app state based on the DB data
            restoreAppState()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
//        saveValuesToDB() // An extra bit of safety measure
    }
    
    fileprivate func readValuesFromDB() {
        if let dbData = UserDefaults.standard.value(forKey: DEFAULT_KEY) as? Data {
            // Now we need to decode the data
            let decoder = JSONDecoder()
            do {
                let parsed = try decoder.decode(ROGSwitchState.self, from: dbData)
                appState = parsed
            } catch let ex {
                print(ex.localizedDescription)
            }
        }
    }
    
    fileprivate func saveValuesToDB() {
        let encoder = JSONEncoder()
        do {
            let encMsg = try encoder.encode(appState)
            UserDefaults.standard.removeObject(forKey: DEFAULT_KEY)
            UserDefaults.standard.setValue(encMsg, forKey: DEFAULT_KEY)
            UserDefaults.standard.synchronize()
        } catch let ex {
            print(ex.localizedDescription)
        }
    }
    
    fileprivate func restoreAppState() {
        // App State restoration will take place in 3 steps
        // - Restore the illuminated state
        // - Restore the color state
        // - Restore the lux state
        
        // As every function call changes the appState, we copy the state before any calls
        let copyState = appState
        
        if /*copyState.isIlluminated*/ true {
            // Restore the color, setting a color automatically turns on the lights
            switch copyState.currentColor {
            case .red:
                handleRed()
            case .green:
                handleGreen()
            case .magenta:
                handleMagenta()
            case .gold:
                handleGold()
            case .rainbow:
                handleRainbow()
            case .breathing:
                handleBreathingMode()
            case .colorCycle:
                handleColorCycle()
                // No default state as this is an exhaustive switch case
            }
            
            // Last step, restore the lux state
//            runShellCommand(rogAuraCore, args: ["brightness", "\(copyState.luxLevel)"])
//            appState.luxLevel = copyState.luxLevel
        } //else {
            // Lights are off, do that
//            handleKbdOff()
        //}
    }
    
    fileprivate func buildMenu() {
        let menu = NSMenu()
        
//        menu.addItem(NSMenuItem(title: "Turn lights on", action: #selector(handleKbdOn), keyEquivalent: ""))
//        menu.addItem(NSMenuItem(title: "Turn lights off", action: #selector(handleKbdOff), keyEquivalent: ""))
//        menu.addItem(NSMenuItem.separator())
        
//        menu.addItem(NSMenuItem(title: "Increase brightness", action: #selector(handleBrightnessUp), keyEquivalent: ""))
//        menu.addItem(NSMenuItem(title: "Decrease Brightness", action: #selector(handleBrightnessDown), keyEquivalent: ""))
//        menu.addItem(NSMenuItem.separator())
        
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
    
    fileprivate func buildErrorMenu() {
        let errorMenu = NSMenu()
        
        errorMenu.addItem(NSMenuItem(title: "Error - macRogAuraCore not found", action: nil, keyEquivalent: ""))
        
        errorMenu.addItem(NSMenuItem.separator())
        
        errorMenu.addItem(NSMenuItem(title: "Quit ROGSwitch", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        statusItem.menu = errorMenu
    }
    
//    @objc fileprivate func handleKbdOn() {
//        if appState.isIlluminated {
//            return
//        }
//
//        // Otherwise, turn on the keyboard lights full brightness
//        appState.luxLevel = 3
//        runShellCommand(rogAuraCore, args: ["brightness", "\(appState.luxLevel)"])
//        appState.isIlluminated = true
//        saveValuesToDB()
//    }
    
//    @objc fileprivate func handleKbdOff() {
//        if !appState.isIlluminated {
//            return
//        }
//
//        // Otherwise, turn off kbd lights
//        appState.luxLevel = 0
//        runShellCommand(rogAuraCore, args: ["brightness", "\(appState.luxLevel)"])
//        appState.isIlluminated = false
//        saveValuesToDB()
//    }
    
//    @objc fileprivate func handleBrightnessUp() {
//        if appState.luxLevel >= 3 {
//            return
//        }
//
//        appState.luxLevel += 1
//        runShellCommand(rogAuraCore, args: ["brightness", "\(appState.luxLevel)"])
//        appState.isIlluminated = true
//        saveValuesToDB()
//    }
    
//    @objc fileprivate func handleBrightnessDown() {
//        if appState.luxLevel <= 0 {
//            return
//        }
//
//        appState.luxLevel -= 1
//        runShellCommand(rogAuraCore, args: ["brightness", "\(appState.luxLevel)"])
//        appState.isIlluminated = appState.luxLevel != 0
//        saveValuesToDB()
//    }
    
    @objc fileprivate func handleRed() {
        runShellCommand(rogAuraCore, args: ["red"])
        appState.isIlluminated = true
        appState.currentColor = .red
        saveValuesToDB()
    }
    
    @objc fileprivate func handleGreen() {
        runShellCommand(rogAuraCore, args: ["green"])
        appState.isIlluminated = true
        appState.currentColor = .green
        saveValuesToDB()
    }
    
    @objc fileprivate func handleMagenta() {
        runShellCommand(rogAuraCore, args: ["magenta"])
        appState.isIlluminated = true
        appState.currentColor = .magenta
        saveValuesToDB()
    }
    
    @objc fileprivate func handleGold() {
        runShellCommand(rogAuraCore, args: ["gold"])
        appState.isIlluminated = true
        appState.currentColor = .gold
        saveValuesToDB()
    }
    
    @objc fileprivate func handleRainbow() {
        runShellCommand(rogAuraCore, args: ["rainbow"])
        appState.isIlluminated = true
        appState.currentColor = .rainbow
        saveValuesToDB()
    }
    
    @objc fileprivate func handleColorCycle() {
        runShellCommand(rogAuraCore, args: ["single_colorcycle", "1"])
        appState.isIlluminated = true
        appState.currentColor = .colorCycle
        saveValuesToDB()
    }
    
    @objc fileprivate func handleBreathingMode() {
        runShellCommand(rogAuraCore, args: ["multi_breathing", "ff0000", "00ff00", "0000ff", "00ffff", "2"])
        appState.isIlluminated = true
        appState.currentColor = .breathing
        saveValuesToDB()
    }
}
