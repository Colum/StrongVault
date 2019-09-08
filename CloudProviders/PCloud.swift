//
//  PCloud.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-08-01.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Foundation

class PCloudStorageProvider: CloudProviderProtocol {
    
    var storageProviderType: AvailableStorageProviders
    
    init() {
        self.storageProviderType = .pCloud
    }
    
    func name() -> String {
        return self.storageProviderType.rawValue
    }
    
    func uploadPart(name: String, data: Data) {
        return
    }
    
    func downloadPart(name: String, dataDict: [String : Data]) {
        
    }
    
    func login(username: String, password: String) -> Bool? {
        //todo
        print("pcloud login")
        return true
    }
    
}
