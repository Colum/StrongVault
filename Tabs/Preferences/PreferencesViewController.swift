//
//  PreferencesViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-07-27.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController, NSTableViewDataSource, NSTextFieldDelegate {
    
    
    @IBOutlet weak var partsPerFileTextField: NSTextField!
    @IBOutlet weak var table: NSScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let integerFormatter = IntegerOnlyValueFormatter()
        partsPerFileTextField.formatter = integerFormatter
        partsPerFileTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableContent(notification:)), name: Notification.Name("cloudProviderListChange"), object: nil)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if obj.object as? NSTextField == partsPerFileTextField {
            if let intVal = Int(partsPerFileTextField.stringValue) {
                PreferencesManager.shared.partsPerFile = intVal
            }
        }
    }

    
    @IBAction func removeCloudProvider(_ sender: NSButton) {
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return CloudProviderManager.shared.providers.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return CloudProviderManager.shared.providers[row]
    }
    
    @objc func updateTableContent(notification: NSNotification) {
        print("notification received; updating table content!")
        // todo reload the table
        
    }
    
}

