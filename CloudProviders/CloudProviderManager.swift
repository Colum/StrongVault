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
    
    var providerServices: [CloudProviderProtocol] = []
    
    
    init() {
        
    }
    
    func removeCloudProviderService(forService: AvailableStorageProviders) {
        var removeAt = -1
        for (index, provider) in providerServices.enumerated() {
            if provider.storageProviderType == forService {
                removeAt = index
                break
            }
        }
        if removeAt != -1 {
            providerServices.remove(at: removeAt)
        }
    }
    
    
    func createCloudProviderService(forService: AvailableStorageProviders) -> CloudProviderProtocol? {
        if usedCloudProviderServiceNames().contains(forService) {
            //service already exists
            return nil
        }
        
        var notifData: [String: AvailableStorageProviders] = [:]
        let newCP: CloudProviderProtocol
        switch forService {
        case .dropbox:
            print("creating dropbox manager")
            let provider = DropboxStorageProvider()
            newCP = provider
            providerServices.append(provider)
            
            // todo use enum for notif name and notif key
            notifData["type"] = .dropbox
            NotificationCenter.default.post(name: Notification.Name("NewCloudProvider"), object: nil, userInfo: notifData)
            
        case .pCloud:
            print("creating pcloud provider")
            let provider = PCloudStorageProvider()
            newCP = provider
            providerServices.append(provider)
            
            // todo use enum for notif name and notif key
            notifData["type"] = .pCloud
            NotificationCenter.default.post(name: Notification.Name("NewCloudProvider"), object: nil, userInfo: notifData)
        }
        return newCP
    }
    
    func usedCloudProviderServiceNames() -> [AvailableStorageProviders] {
        var usedCP: [AvailableStorageProviders] = []

        for cp in providerServices {
            let cpName = cp.storageProviderType
            usedCP.append(cpName)
        }
        
        return usedCP
    }
    
    func getCloudProviderService(providerType: AvailableStorageProviders) -> CloudProviderProtocol? {
        for prov in providerServices {
            if prov.storageProviderType == providerType {
                return prov
            }
        }
        return nil
    }

}


protocol CloudProviderProtocol {
    func name() -> String
    func uploadParts(names: [String], data: [Data])
    func downloadParts(names: [String]) -> [Data]
    func login(username: String, password: String) -> Bool?
    var storageProviderType: AvailableStorageProviders { get set }
    // func providerImage() -> Image
}


enum AvailableStorageProviders: String {
    case dropbox = "Dropbox"
    case pCloud = "pCloud"
    
    static let allValues = [dropbox, pCloud]
}

