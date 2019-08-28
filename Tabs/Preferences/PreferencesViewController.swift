//
//  PreferencesViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-07-27.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    

    @IBOutlet weak var partsPerFileTextField: NSTextField!
    @IBOutlet weak var scrollView: NSScrollView!
    let tableView = NSTableView()
    var registeredCloudProvider: NSMutableArray! = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let integerFormatter = IntegerOnlyValueFormatter()
        partsPerFileTextField.formatter = integerFormatter
        partsPerFileTextField.delegate = self
        partsPerFileTextField.stringValue = String(PreferencesManager.shared.partsPerFile)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableContent(notification:)), name: Notification.Name("NewCloudProvider"), object: nil)
        
        // todo do in storyboard?
        tableView.headerView?.isHidden = false
        tableView.selectionHighlightStyle = .regular
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.height, .width]
        tableView.usesAlternatingRowBackgroundColors = true
        let col1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Name"))
        col1.headerCell = NSTableHeaderCell(textCell: "Name")
        tableView.addTableColumn(col1)
        //
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        if tableView.selectedRow < 0 || registeredCloudProvider.count < 1{
            print("nothing to remove")
            return
        }
        
        guard let rowToRemove = registeredCloudProvider.object(at: tableView.selectedRow) as? String else {
            print("could not determine CP type to remove")
            return
        }

        DispatchQueue.main.async { // update UI on separate thread
            self.tableView.beginUpdates()
            self.registeredCloudProvider.removeObject(at: self.tableView.selectedRow)
            self.tableView.reloadData()
            self.tableView.endUpdates()
        }
        
        if let type = AvailableStorageProviders(rawValue: rowToRemove) {
            CloudProviderManager.shared.removeCloudProviderService(forService: type)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.registeredCloudProvider.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.registeredCloudProvider.object(at: row)
    }
    
    @objc func updateTableContent(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let providerType = dict["type"] as? AvailableStorageProviders {
                self.registeredCloudProvider.add(providerType.rawValue)
                DispatchQueue.main.async { // update UI on separate thread
                    let indexSet: IndexSet = IndexSet(integer: self.registeredCloudProvider.count - 1)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexSet, withAnimation: .effectFade)
                    self.tableView.reloadData()
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    
}

