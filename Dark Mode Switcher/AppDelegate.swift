//
//  AppDelegate.swift
//  Dark Mode Switcher
//
//  Created by Ben Leggiero on 2018-05-29.
//  Copyright © 2018 Ben Leggiero. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let currentAppearance = AppleInterfaceStyle.current.appearance
        
        NSApp.windows.forEach {
            $0.titlebarAppearsTransparent = true
            $0.appearance = currentAppearance
        }
        
        AppleInterfaceStyle.listenForChanges { newStyle in
            let newAppearance = newStyle.appearance
            
            NSApp.windows.forEach {
                $0.appearance = newAppearance
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
