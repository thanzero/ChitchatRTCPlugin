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
    
    let socket = SocketIOClient(socketURL: NSURL(fileURLWithPath:"ws://203.113.25.44:3000"))
    
    func getCallerID(){

        socket.on("id") {data, ack in
            print("Message for you! \(data[0])")
        }
        socket.connect()
        
    }
    
    func freeCall(command:CDVInvokedUrlCommand){
        
        
        self.command = command
        
        print(self.command)
        
        self.getCallerID()

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

    func videoCall(command:CDVInvokedUrlCommand){
        self.command = command
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
