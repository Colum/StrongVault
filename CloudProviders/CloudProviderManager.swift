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
    
    func removeCloudProvider(forService: AvailableStorageProviders) {
        var removeAt = -1
        for (index, provider) in providers.enumerated() {
            if provider.storageProviderType == forService {
                removeAt = index
                break
            }
        }
        if removeAt != -1 {
            providers.remove(at: removeAt)
        }
    }
    
    
    func createCloudProviderService(forService: AvailableStorageProviders) {
        var notifData: [String: AvailableStorageProviders] = [:]
        switch forService {
        case .dropbox:
            print("creating dropbox manager")
            let provider = DropboxStorageProvider(type: .dropbox)
            providers.append(provider)
            
            // todo use enum for notif name and notif key
            notifData["type"] = .dropbox
            NotificationCenter.default.post(name: Notification.Name("NewCloudProvider"), object: nil, userInfo: notifData)
            
        case .pCloud:
            print("creating pcloud provider")
            let provider = PCloudStorageProvider(type: .pCloud)
            providers.append(provider)
            
            // todo use enum for notif name and notif key
            notifData["type"] = .pCloud
            NotificationCenter.default.post(name: Notification.Name("NewCloudProvider"), object: nil, userInfo: notifData)
            
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

