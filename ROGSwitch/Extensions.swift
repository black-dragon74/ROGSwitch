//
//  Extensions.swift
//  ROGSwitch
//
//  Created by Nick on 11/4/19.
//  Copyright © 2019 Nick. All rights reserved.
//

import Foundation

@discardableResult
func runShellCommand(_ command: String, args: [String]) -> String? {
    
    #if DEBUG
    print("Running: \(command) with args: \(args)")
    #endif
    
    let task = Process()
    task.executableURL = URL(fileURLWithPath: command)
    task.arguments = args
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
        try task.run()
    }
    catch let ex {
        return ex.localizedDescription
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    #if DEBUG
    print("Output: \(output ?? "")")
    #endif
    
    task.waitUntilExit()
    
    return output
}
