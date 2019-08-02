//
//  DropBox.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-08-01.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Foundation
import SwiftyDropbox

class DropboxStorageProvider: CloudProviderProtocol {
    var storageProviderType: AvailableStorageProviders
    var client: DropboxClient?
    
    init(type: AvailableStorageProviders) {
        self.storageProviderType = type
        self.client = DropboxClientsManager.authorizedClient
    }
    
    func name() -> String {
        return self.storageProviderType.rawValue
    }
    
    
    func uploadParts(names: [String], data: [Data]) {
        
    }
    
    func downloadParts(names: [String]) -> [Data] {
        //todo
        let d = Data()
        return [d]
    }
    
    
    
    
}
