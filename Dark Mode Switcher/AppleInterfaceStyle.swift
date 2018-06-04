//
//  AppleInterfaceStyle.swift
//  Dark Mode Switcher
//
//  Created by Ben Leggiero on 2018-06-04.
//  Copyright © 2018 Ben Leggiero. All rights reserved.
//

import Cocoa



public enum AppleInterfaceStyle {
    case light
    case dark
}



public extension AppleInterfaceStyle {
    
    public static let userDefaultsKey = "AppleInterfaceStyle"
    public static let userDefaultsDarkValue = "Dark"
    public static let userDefaultsLightValue: String? = nil
    
    
    public static var current: AppleInterfaceStyle {
        get {
            switch UserDefaults.standard.string(forKey: userDefaultsKey) {
            case .some(userDefaultsDarkValue):
                return .dark
                
            case .some(let style):
                print("Magical new style: \(style)")
                fallthrough
                
            case .none:
                return .light
            }
        }
        
        
        set {
            switch newValue {
            case .dark:
                setDarkModeViaAppleScript(newValue: true)
                
            case .light:
                setDarkModeViaAppleScript(newValue: false)
            }
        }
    }
    
    
    public var appearance: NSAppearance {
        switch self {
        case .dark: return NSAppearance(named: NSAppearanceNameVibrantDark)!
        case .light: return NSAppearance(named: NSAppearanceNameVibrantLight)!
        }
    }
}



public extension AppleInterfaceStyle {
    
    public typealias ChangeReactor = (_ newStyle: AppleInterfaceStyle) -> Void
    
    
    
    public static let userDefaultsKeyPath = "values.\(userDefaultsKey)"
    public static let udController = NSUserDefaultsController(defaults: .standard, initialValues: nil)
    
    
    public static func listenForChanges(reactor: @escaping ChangeReactor) {
        
        @objc
        class Observer: NSObject {
            
            let reactor: ChangeReactor
            
            init(reactor: @escaping ChangeReactor) {
                self.reactor = reactor
            }
            
            override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                reactor(AppleInterfaceStyle.current)
            }
        }
        
        let observer = Observer(reactor: reactor)
        observers.insert(observer)
        
        udController.addObserver(observer, forKeyPath: userDefaultsKeyPath, options: .new, context: nil)
    }
}



private var observers = Set<NSObject>()



private func setDarkModeViaAppleScript(newValue: Bool) {
    // osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
    
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to \(newValue)'"]
    process.launch()
}
