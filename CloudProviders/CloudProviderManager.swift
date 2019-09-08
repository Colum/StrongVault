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
    
    var filesUploaded: [String: [[String: String]]] = [:] // [fileName: [partLocation: partName]]
    
    
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
    
    func uploadFile(fileAt: URL) -> Bool {
        
        do {
            var data = try Data(contentsOf: fileAt)
            
            let shardsPerFile = PreferencesManager.shared.partsPerFile
            let bytesPerShard = Int(ceil(Float(data.count) / Float(shardsPerFile)))
            let fileName = fileAt.lastPathComponent
            
            filesUploaded[fileName] = [[String: String]]()
            
            for shardNum in 0..<shardsPerFile {
                // store the way the file was broken down in memory
                // [fileName: [[partLocation: partName]]]
                let randomProvider = providerServices.randomElement()!
                let randomFileName = randomString()
                let dict = [randomProvider.storageProviderType.rawValue: randomFileName]
                
                filesUploaded[fileName]!.append(dict)
                
                var chunk:Data
                let chunkBase = shardNum * bytesPerShard
                var diff = bytesPerShard
                if(shardNum == shardsPerFile - 1) {
                    diff = data.count - chunkBase
                }
                
                let range:Range<Data.Index> = chunkBase..<(chunkBase + diff)
                chunk = data.subdata(in: range)
                randomProvider.uploadPart(name: randomFileName, data: chunk)
                
            }
            
            
            return true
        } catch let error {
            print(error)
        }
        return false
    }
    
    func downloadFile(fileName: String) {
        // [partName:Data]]
        var dataDict:[String:Data] = [:]
        
        guard let fileLocation = filesUploaded[fileName] else {
            print("unknown file: \(fileName)")
            return
        }
        
        for fileInfo in fileLocation {
            for part in fileInfo {
                let cloudService = part.key
                let partName = part.value
                
                if cloudService == AvailableStorageProviders.dropbox.rawValue {
                    if let dropboxSP = getCloudProviderService(providerType: .dropbox) {
                        dropboxSP.downloadPart(name: partName, dataDict: dataDict)
                    }
                } else if cloudService == AvailableStorageProviders.pCloud.rawValue {
                    if let pcloudSP = getCloudProviderService(providerType: .pCloud) {
                        pcloudSP.downloadPart(name: partName, dataDict: dataDict)
                    }
                }
            }
        }
        
        
        
    }
    
    private func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).map{ _ in letters.randomElement()! })
    }

}


protocol CloudProviderProtocol {
    func name() -> String
    func uploadPart(name: String, data: Data)
    func downloadPart(name: String, dataDict: [String: Data])
    func login(username: String, password: String) -> Bool?
    var storageProviderType: AvailableStorageProviders { get set }
    // func providerImage() -> Image
}


enum AvailableStorageProviders: String {
    case dropbox = "Dropbox"
    case pCloud = "pCloud"
    
    static let allValues = [dropbox, pCloud]
}

