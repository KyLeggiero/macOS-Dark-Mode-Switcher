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

        AppleInterfaceStyle.listenForChanges { newStyle in
            switch newStyle {
            case .light:
                self.darkModeCheckBox.state = NSOffState
                
            case .dark:
                self.darkModeCheckBox.state = NSOnState
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func didChangeDarkModeCheckbox(_ sender: NSButton) {
        let newState: AppleInterfaceStyle = NSOnState == sender.state ? .dark : .light
        AppleInterfaceStyle.current = newState
        
        sender.window?.appearance = newState.appearance
    }
}

