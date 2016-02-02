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
    var callerId:String
    
    let socket = SocketIOClient(socketURL: NSURL(fileURLWithPath:"ws://203.113.25.44:3000"))
    
    func getCallerID(){

        socket.on("id") {data, ack in
            self.callerId = data[0]
            print("Message for you! \(data[0])")
            self.sendPluginResponse(self.callerId)
            self.callUI()
            
        }
        socket.connect()
        
    }
    
    func freeCall(command:CDVInvokedUrlCommand){
        
        
        /*
var message = command.arguments[0] as String

message = message.uppercaseString // Prove the plugin is actually doing something

var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
commandDelegate.sendPluginResult(pluginResult, callbackId:command.callbackId)
*/

        self.command = command
        self.getCallerID()
    }

    func videoCall(command:CDVInvokedUrlCommand){
        self.command = command
    }
    
    
    func callUI()
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
        sendPluginResponse("id")
    }
    
    //private func sendPluginResponse(response: [String: AnyObject]) {
    private func sendPluginResponse(response: String)
    {
        //let result = CDVPluginResult(status: CDVCommandStatus_OK , messageAsDictionary: response)
        let result = CDVPluginResult(status: CDVCommandStatus_OK , messageAsString: response)
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
