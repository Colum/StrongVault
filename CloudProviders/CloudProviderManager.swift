//
//  CloudProviderManager.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-07-26.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Foundation
import Cocoa

class CloudProviderManager {
    
    static let shared = CloudProviderManager()
    
    var providers: [CloudProviderProtocol] = []
    
    
    init() {
        
    }
    
    
    func createCloudProviderService(forService: AvailableStorageProviders) {
        switch forService {
        case .dropbox:
            print("creating dropbox manager")
            let provider = DropboxStorageProvider(type: .dropbox)
            providers.append(provider)
        case .pCloud:
            print("creating pcloud provider")
            let provider = PCloudStorageProvider(type: .pCloud)
            providers.append(provider)
        }
    }
    
    func usedCloudProviderNames() -> [AvailableStorageProviders] {
        var usedCP: [AvailableStorageProviders] = []

        for cp in providers {
            let cpName = cp.storageProviderType
            usedCP.append(cpName)
        }
        
        return usedCP
    }

}


protocol CloudProviderProtocol {
    func name() -> String
    func uploadParts(names: [String], data: [Data])
    func downloadParts(names: [String]) -> [Data]
    var storageProviderType: AvailableStorageProviders { get set }
    // func providerImage() -> Image
}


enum AvailableStorageProviders: String {
    case dropbox = "Dropbox"
    case pCloud = "pCloud"
    
    static let allValues = [dropbox, pCloud]
}

