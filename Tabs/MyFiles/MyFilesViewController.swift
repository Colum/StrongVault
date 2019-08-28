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
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Select File to Upload";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = [];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let url = dialog.url {
                CloudProviderManager.shared.uploadFile(fileAt: url)
            }
            
        } else {
            return
        }
    }
    
    
}
