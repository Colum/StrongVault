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
    
    init(type: AvailableStorageProviders) {
        self.storageProviderType = type
    }
    
    func name() -> String {
        return self.storageProviderType.rawValue
    }
    
    func uploadParts(names: [String], data: [Data]) {
        return
    }
    
    func downloadParts(names: [String]) -> [Data] {
        //todo
        let d = Data()
        return [d]
    }
    
    
    
    
}