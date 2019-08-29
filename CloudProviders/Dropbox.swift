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
    let homeFolder = "/StrongVault"
    let extensionName = ".dat"
    var retryData:[String: Data] = [:] // dict which holds data parts which failed to upload due to "too many retries"
    
    init() {
        self.storageProviderType = .dropbox
        self.client = DropboxClientsManager.authorizedClient
        ensureStrongVaultFolderExists()
        backgroundRetryThread()
    }
    
    func name() -> String {
        return self.storageProviderType.rawValue
    }
    
    private func backgroundRetryThread() {
        DispatchQueue.global(qos: .background).async {
            while true {
                if let dataToUpload = self.retryData.randomElement() {
                    let fileName = dataToUpload.key
                    let data = self.retryData[fileName]
                    
                    self.retryData.removeValue(forKey: fileName)
                    self.uploadPart(name: fileName, data: data!)
                }
            }
        }
    }
    
    
    private func ensureStrongVaultFolderExists() {
        if let cli = client {
            // root path is empty string
            cli.files.listFolder(path: "").response { (listFolderResult, errors) in
                var homeFolderExists = false
                if let folders = listFolderResult {
                    for folder in folders.entries {
                        if folder.name == self.homeFolder {
                            homeFolderExists = true
                        }
                    }
                    if !homeFolderExists {
                        cli.files.createFolderV2(path: self.homeFolder).response { response, error in
                            if let response = response {
                                print(response)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func uploadPart(name: String, data: Data) {
        let location = homeFolder + "/\(name)" + extensionName
        if let cli = client {
            cli.files.upload(path: location , input: data).response { (fileMetaData, errors) in
                if let errs = errors {
                    print("--")
                    if errs.description.contains("too_many_write_operations") {
                        self.retryData[name] = data
                    }
                }
            }
        }
    }
    
    
    func downloadPart(name: String) -> Data {
        //todo
        let d = Data()
        return d
    }
    
    
    func login(username: String, password: String) -> Bool? {
        return nil // required protocol method, dropbox auth is through browser and with app redirect
    }
    
    
    
}
