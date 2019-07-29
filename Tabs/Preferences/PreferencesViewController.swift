//
//  PreferencesViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-07-27.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController, NSTableViewDataSource {
    
    var val = ["banana", "pear", "apple"]
    
    @IBOutlet weak var partsPerFileTextField: NSTextField!
    @IBOutlet weak var TableView: NSScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let integerFormatter = IntegerOnlyValueFormatter()
        partsPerFileTextField.formatter = integerFormatter
    }

    
    @IBAction func addCloudProvider(_ sender: NSButton) {
    }
    
    @IBAction func removeCloudProvider(_ sender: NSButton) {
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        //return CloudProviderManager.shared.providers.count
        return val.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        //return CloudProviderManager.shared.providers[row]
        return val[row]
    }
    
    
}
