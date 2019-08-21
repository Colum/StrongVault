//
//  NewCloudProviderViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-08-01.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa
import SwiftyDropbox
import PCloudSDKSwift

class NewCloudProviderViewController: NSViewController {
    

    @IBOutlet weak var dropBoxButton: NSButton!
    @IBOutlet weak var pCloudButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableUsedCPs()
        listenForClose()
    }
    
    func disableUsedCPs() {
        let usedCPs = CloudProviderManager.shared.usedCloudProviderNames()
        for cp in usedCPs {
            if cp == .dropbox {
                dropBoxButton.isEnabled = false
            }
            if cp == .pCloud {
                pCloudButton.isEnabled = false
            }
        }
    }
    
    func listenForClose() {
        // is there a better way to do this ?
        NotificationCenter.default.addObserver(self, selector: #selector(close(sender:)), name: Notification.Name("CloseAddCloudProviderView"), object: nil)
    }
    
    @objc func close(sender: Any) {
        self.dismiss(sender)
    }
    
    
    @IBAction func addDropBox(_ sender: Any) {
        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        NSWorkspace.shared.open(url)
        })
        self.dismiss(self)
    }
    
}
