//
//  MyFilesViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-08-28.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa

class MyFilesViewController: NSViewController {

    @IBOutlet weak var filesTable: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func uploadNewFile(_ sender: Any) {
        if CloudProviderManager.shared.providerServices.count == 0 {
            let alert = NSAlert()
            alert.messageText = "No cloud provider configured!"
            alert.informativeText = "At least one cloud provider must be configured"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Select File to Upload";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = [];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let url = dialog.url {
                if CloudProviderManager.shared.uploadFile(fileAt: url) {
                    // add file to table view
                }
            }
            
        } else {
            return
        }
    }
    
    
}
