//
//  NewCloudProviderViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-08-01.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa

class NewCloudProviderViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addPCloud(_ sender: NSButton) {
        print("add pcloud")
        self.dismiss(self)
    }
    
    
    @IBAction func addDropBox(_ sender: Any) {
        print("add dropbox")
        self.dismiss(self)
    }
    
}
