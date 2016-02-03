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
    
    let socket = SocketIOClient(socketURL: NSURL(string:"ws://203.113.25.44:3000")! )
    
    func getCallerID(){
        
        self.socket.on("connect") {data, ack in
            print("Message for you! \(data)")
        }
        
        self.socket.on("id") {data, ack in
            
            let caller_id:String? = data[0] as? String
            
            self.sendPluginResponse(caller_id!)
        }
        
        self.socket.on("readyToStream"){data ,ack in
            
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
        
        freecallNav.closeCallback = endCall
        
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
    
    private func sendPluginResponse(response: String) {
        let result = CDVPluginResult(status: CDVCommandStatus_OK , messageAsString: response)
        self.commandDelegate!.sendPluginResult(result, callbackId: self.command.callbackId)
    }
    
    private func endCall(){
        
    }
    
}
