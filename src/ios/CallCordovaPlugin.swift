//
//  CallCordovaPlugin.swift
//  CallCordovaPlugin
//
//  Created by Prathan B. on 1/27/16.
//  Copyright © 2016 Prathan B. All rights reserved.
//

import UIKit

@objc(CallCordovaPlugin) class CallCordovaPlugin : CDVPlugin {

    var command = CDVInvokedUrlCommand()
    
    func getCallerID(command: CDVInvokedUrlCommand){
        self.command = command
        
    }
}
