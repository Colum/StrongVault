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
    
    
    func addProvider(provider: CloudProviderProtocol) {
        providers.append(provider)
    }

}


protocol CloudProviderProtocol {
    func name() -> String
    func active() -> Bool
    func signIn() -> Bool
    func signOut() -> Bool
    func uploadPart(name: String, data: Data)
    func downloadPart(name: String) -> Data
    var storageProviderType: AvailableStorageProviders { get set }
    // func providerImage() -> Image
}


enum AvailableStorageProviders: String {
    case Dropbox = "Dropbox"
    case pCloud = "pCloud"
}

