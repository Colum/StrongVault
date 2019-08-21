//
//  CredentialsViewController.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-08-21.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa

class PCloudCredentialsViewController: NSViewController {

    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(sender)
        NotificationCenter.default.post(name: Notification.Name("CloseAddCloudProviderView"), object: nil, userInfo: nil)
    }
    
    @IBAction func submitCrendentials(_ sender: Any) {
        let un = usernameTextField.stringValue
        let pw = passwordTextField.stringValue
        
        var pCloudProviderService: CloudProviderProtocol?
        
        if let provider = CloudProviderManager.shared.createCloudProviderService(forService: .pCloud) {
            // pcloud service provider DNE, create first
            pCloudProviderService = provider
        } else {
            // pcloud service provider already exists, retrieve and use
            if let provider = CloudProviderManager.shared.getCloudProviderService(providerType: .pCloud) {
                pCloudProviderService = provider
            }
        }
        
        if let authResult = pCloudProviderService?.login(username: un, password: pw) {
            if !authResult {
                print("auth failed")
                // todo show feedback to user
            }
        }
        close(self)
    }
    

    
}
