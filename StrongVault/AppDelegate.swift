//
//  AppDelegate.swift
//  StrongVault
//
//  Created by Colum McClay on 2019-07-26.
//  Copyright © 2019 Colum McClay. All rights reserved.
//

import Cocoa
import SwiftyDropbox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DropboxClientsManager.setupWithAppKeyDesktop("rsa0gm8pqutzdxb")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

