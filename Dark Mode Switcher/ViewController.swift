//
//  ViewController.swift
//  Dark Mode Switcher
//
//  Created by Ben Leggiero on 2018-05-29.
//  Copyright © 2018 Ben Leggiero. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var darkModeCheckBox: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppleInterfaceStyle.listenForChanges(alsoCallNow: true) { newStyle in
            switch newStyle {
            case .light:
                self.darkModeCheckBox.state = .off
                
            case .dark:
                self.darkModeCheckBox.state = .on
            }
            
            return .continueListeningForChanges
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func didChangeDarkModeCheckbox(_ sender: NSButton) {
        let newState: AppleInterfaceStyle = (.on == sender.state ? .dark : .light)
        AppleInterfaceStyle.current = newState
        
        sender.window?.appearance = newState.appearance(vibrant: true)
    }
}

