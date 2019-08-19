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
    @IBOutlet weak var scrollView: NSScrollView!
    let tableView = NSTableView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let integerFormatter = IntegerOnlyValueFormatter()
        partsPerFileTextField.formatter = integerFormatter
        partsPerFileTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableContent(notification:)), name: Notification.Name("cloudProviderListChange"), object: nil)
        
        // todo do in storyboard?
        tableView.headerView?.isHidden = false
        tableView.selectionHighlightStyle = .regular
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.height, .width]
        tableView.usesAlternatingRowBackgroundColors = true
        let col1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Name"))
        col1.headerCell = NSTableHeaderCell(textCell: "Name")
        tableView.addTableColumn(col1)
        
        scrollView.documentView = tableView
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if obj.object as? NSTextField == partsPerFileTextField {
            if let intVal = Int(partsPerFileTextField.stringValue) {
                PreferencesManager.shared.partsPerFile = intVal
            }
        }
    }

    
    @IBAction func removeCloudProvider(_ sender: NSButton) {
        // todo
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableView.numberOfRows
        // return CloudProviderManager.shared.providers.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        // return CloudProviderManager.shared.providers[row]
        return tableView.rowView(atRow: row, makeIfNecessary: false)
    }
    
    @objc func updateTableContent(notification: NSNotification) {
        
        print("notification received; updating table content!")
        if let dict = notification.userInfo as NSDictionary? {
            if let providerType = dict["type"] as? AvailableStorageProviders {
                print(providerType)
                let indexSet: IndexSet = IndexSet(integer: CloudProviderManager.shared.providers.count - 1)
                
                tableView.beginUpdates()
                if providerType == .dropbox {
                    tableView.insertRows(at: indexSet, withAnimation: .effectFade)
                }
                tableView.reloadData()
                tableView.endUpdates()
            }
        }
        
        
    }
    
}

