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
    
    func freeCall(command:CDVInvokedUrlCommand){
        self.command = command
        
        let storyboard = UIStoryboard(name: "CallStoryboard", bundle: nil)
        
        let freecallNav = storyboard.instantiateViewControllerWithIdentifier("FreeCallViewController") as! FreeCallViewController
        
        freecallNav.closeCallback = modalDidClose
        
        var presentationStyle: UIModalPresentationStyle
        if #available(iOS 8, *) {
            presentationStyle = .OverCurrentContext
        } else {
            presentationStyle = .CurrentContext
        }
        
        viewController!.modalPresentationStyle = presentationStyle
        freecallNav.modalPresentationStyle = presentationStyle
        viewController!.modalTransitionStyle = .CoverVertical
        viewController!.presentViewController(freecallNav, animated: true, completion: nil)
        
    }
    
    func modalDidClose() {
        sendPluginResponse(responseDict(.Normal, index: nil))
    }
    
    private func sendPluginResponse(response: [String: AnyObject]) {
        
        let result = CDVPluginResult(status: CDVCommandStatus_OK , messageAsDictionary: response)
        self.commandDelegate!.sendPluginResult(result, callbackId: command.callbackId)
    }
    
    private func responseDict(responseType: Response, index: Int?) -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict["action"] = responseType.rawValue
        if let index = index { dict["index"] = index }
        return dict
    }
    
    private enum Response: String {
        case Normal = "none"
        case Delete = "delete"
    }

}
