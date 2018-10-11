//
//  NSAppearance Extensions.swift
//  Ionic Files Utilities
//
//  Created by Ben Leggiero on 2018-10-10.
//  Copyright © 2018 Ben Leggiero BH-1-PS.
//  https://github.com/BenLeggiero/macOS-Dark-Mode-Switcher
//

import AppKit



public extension NSAppearance {
    
    /// The standard Aqua appearance.
    public static var aqua: NSAppearance! {
        #if swift(>=4)
            return NSAppearance(named: .aqua)
        #else
            return NSAppearance(named: NSAppearanceNameAqua)
        #endif
    }
    
    
    /// The vibrant appearance for light content.
    /// This should only be set on an `NSVisualEffectView` or one of its subviews.
    public static var vibrantLight: NSAppearance! {
        #if swift(>=4)
            return NSAppearance(named: .vibrantLight)
        #else
            return NSAppearance(named: NSAppearanceNameVibrantLight)
        #endif
    }
    
    /// The vibrant appearance for dark content.
    /// This should only be set on an NSVisualEffectView or one of its subviews.
    public static var vibrantDark: NSAppearance! {
        #if swift(>=4)
            return NSAppearance(named: .vibrantDark)
        #else
            return NSAppearance(named: NSAppearanceNameVibrantDark)
        #endif
    }
    
    
    #if swift(>=4.2)
    /// The standard dark system appearance.
    @available(macOS 10.14, *)
    public static var darkAqua: NSAppearance! {
        return NSAppearance(named: .darkAqua)
    }
    
    
    /// A high-contrast version of the standard light system appearance.
    @available(macOS 10.14, *)
    public static var accessibilityHighContrastAqua: NSAppearance! {
        return NSAppearance(named: .accessibilityHighContrastAqua)
    }
    
    
    /// A high-contrast version of the standard dark system appearance.
    @available(macOS 10.14, *)
    public static var accessibilityHighContrastDarkAqua: NSAppearance! {
        return NSAppearance(named: .accessibilityHighContrastDarkAqua)
    }
    
    
    /// A high-contrast version of the light vibrant appearance.
    @available(macOS 10.14, *)
    public static var accessibilityHighContrastVibrantLight: NSAppearance! {
        return NSAppearance(named: .accessibilityHighContrastVibrantLight)
    }
    
    
    /// A high-contrast version of the dark vibrant appearance.
    @available(macOS 10.14, *)
    public static var accessibilityHighContrastVibrantDark: NSAppearance! {
        return NSAppearance(named: .accessibilityHighContrastVibrantDark)
    }
    #endif
}

