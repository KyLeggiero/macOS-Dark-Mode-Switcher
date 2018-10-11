//
//  AppleInterfaceStyle.swift
//  Dark Mode Switcher
//
//  Created by Ben Leggiero on 2018-06-04.
//  Copyright © 2018 Ben Leggiero BH-1-PS.
//  https://github.com/BenLeggiero/macOS-Dark-Mode-Switcher
//

import Cocoa



/// The style of the operating system's interface.
/// At time of writing this only applies to macOS 10.12 (Sierra) and newer
public enum AppleInterfaceStyle {
    /// The default, light interface style.
    /// Apps have a light-colored background with dark or color text
    case light
    
    /// The dark interface style.
    /// Apps have a dark-colored background with light or color text
    case dark
}



public extension AppleInterfaceStyle {
    
    fileprivate static let userDefaultsKey = "AppleInterfaceStyle"
    fileprivate static let userDefaultsDarkValue = "Dark"
    fileprivate static let userDefaultsLightValue: String? = nil
    
    
    /// The current interface style of the operating system at large
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
    
    
    /// Generates a `NSAppearance` object corresponding to this interface style
    ///
    /// - Parameter vibrant: [optional] Indicates whether you want the returned appearance to be vibrant. This may be
    ///                      ignored in certain OS versions based on the availability of appearances.
    ///                      Defaults to `false`.
    /// - Returns: An `NSAppearance` that corresponds to this interface style
    public func appearance(vibrant: Bool = false) -> NSAppearance {
        switch self {
        case .dark:
            #if swift(>=4.2)
                if #available(macOS 10.14, *) {
                    return vibrant ? .vibrantDark : (.darkAqua ?? .vibrantDark)
                }
                else {
                    return .vibrantDark
                }
            #else
                return .vibrantDark
            #endif
            
        case .light:
            return vibrant ? .vibrantLight : .aqua
        }
    }
}



public extension AppleInterfaceStyle {
    
    /// Listens for changes to the global OS interface style. On a change, `reactor` is called
    ///
    /// - Parameters:
    ///   - alsoCallNow: [optional] if `true`, `reactor` is called immediately, so you only have to write the reaction
    ///                  closure once. Defaults to `false`.
    ///   - reactor:     The function that will be called when the global OS style changes
    public static func listenForChanges(alsoCallNow: Bool = false, reactor: @escaping ChangeReactor) {
        
        /// Allows us to observe changes to the Apple Interface Style system setting
        @objc
        class Observer: NSObject {
            
            static var observers = Set<Observer>()
            
            static let userDefaultsKeyPath = "values.\(AppleInterfaceStyle.userDefaultsKey)"
            static let userDefaultsController = NSUserDefaultsController(defaults: .standard, initialValues: nil)
            
            let reactor: AppleInterfaceStyle.ChangeReactor
            
            init(reactor: @escaping AppleInterfaceStyle.ChangeReactor) {
                self.reactor = reactor
                
                super.init()
                
                Observer.userDefaultsController.addObserver(self, forKeyPath: Observer.userDefaultsKeyPath, options: .new, context: nil)
            }
            
            
            deinit {
                Observer.userDefaultsController.removeObserver(self, forKeyPath: Observer.userDefaultsKeyPath)
            }
            
            
            override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                callReactor(for: .current)
            }
            
            
            func callReactor(for style: AppleInterfaceStyle) {
                let response = reactor(style)
                
                switch response {
                case .continueListeningForChanges:
                    break
                    
                case .stopListeningForChanges:
                    // This will remove the only reference to this instance, which immediately calls our `deinit` block
                    // and removes us from being an observer
                    Observer.observers.remove(self)
                }
            }
        }
        
        
        
        let observer = Observer(reactor: reactor)
        Observer.observers.insert(observer)
        
        if alsoCallNow {
            observer.callReactor(for: .current)
        }
    }
    
    
    
    /// Called when the user interface style changes
    public typealias ChangeReactor = (_ newStyle: AppleInterfaceStyle) -> ChangeReactorResponse
}



/// Change listeners can respond with one of these after a change notification has been sent out
public enum ChangeReactorResponse {
    /// If there are further changes, call this same function again with the new value
    case continueListeningForChanges
    
    /// Do not call this function again; further changes will not call this function
    case stopListeningForChanges
}



/// Uses AppleScript to set the system-wide dark mode
///
/// - Parameter newValue: The new value of the system-wide dark mode
private func setDarkModeViaAppleScript(newValue: Bool) {
    // Try it in the Terminal:
    // tell application "System Events" to tell appearance preferences to set dark mode to not dark mode
    
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to \(newValue)'"]
    process.launch()

    // If this stops working, try using `NSAppleScript` instead
}
