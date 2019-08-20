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
    }
    
    func disableUsedCPs() {
        let usedCPs = CloudProviderManager.shared.usedCloudProviderNames()
        for cp in usedCPs {
            if cp == .dropbox {
                dropBoxButton.isEnabled = false
            }
            if cp == .pCloud {
                dropBoxButton.isEnabled = false
            }
        }
    }
    
    
    @IBAction func addPCloud(_ sender: NSButton) {
        print("pcloud auth")
        
        
        let wvcp = WebViewControllerPresenterDesktop(presentingViewController: self)
        OAuth.performAuthorizationFlow(view: wvcp,
                                       appKey: "TgacIxvpqJR",
                                       storeToken: { accessToken, userId in
                                        // Store the token in a persistent storage. Or not.
                                        print("--")
                                        print(accessToken)
                                        print(userId)
        },
                                       { result in
                                        if case .success(let token, _) = result {
                                            print("-__")
                                            print(token)
                                            let client = PCloud.createClient(accessToken: token)
                                            // Use the client.
                                        }
        })
        
        
        self.dismiss(self)
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
