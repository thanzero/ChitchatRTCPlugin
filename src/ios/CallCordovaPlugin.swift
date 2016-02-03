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
    
    //    let socket = SocketIOClient(socketURL: NSURL(fileURLWithPath:"ws://203.113.25.66:3000") ,options:["log": true])
    
    let socket = SocketIOClient(socketURL: NSURL(string:"ws://203.113.25.44:3000")! )
    
    //    let socket = SocketIOClient(socketURL: "203.113.25.66:3000", options:["log": true])
    
    
    func getCallerID(){
        
        self.socket.on("connect") {data, ack in
            print("Message for you! \(data)")
        }
        
        self.socket.on("id") {data, ack in
            
            let caller_id:String? = data[0] as? String
            
            let result = CDVPluginResult(status: CDVCommandStatus_OK , messageAsString:  caller_id)
            
            self.commandDelegate!.sendPluginResult(result, callbackId: self.command.callbackId)
            
        }
        
        self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        
        socket.connect()
        
    }
    
    func freeCall(command:CDVInvokedUrlCommand){
        
        self.command = command
        
        getCallerID()
        freeCallUI()
    }
    
    func freeCallUI()
    {
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
