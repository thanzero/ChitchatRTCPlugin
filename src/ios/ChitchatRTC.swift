//
//  ChitchatRTC.swift
//  ChitchatRTC
//
//  Created by Prathan B.
//

import UIKit

@objc(ChitchatRTC) class ChitchatRTC: CDVPlugin {

    var command = CDVInvokedUrlCommand()
    var waitforEndCallCommand = CDVInvokedUrlCommand()
    
    let socket = SocketIOClient(socketURL: NSURL(string: "ws://203.113.25.44:3000")!)
    
    func freeCall(command: CDVInvokedUrlCommand) {
        self.command = command

        socket.on("connect"){ data , ack in
            print("socket on connect:: \(data)")
        }
        
        socket.on("id"){ data , ack in
            print("socket on id:: \(data)")
            
            let callid:String = data[0] as! String
            
            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:callid)
            self.commandDelegate!.sendPluginResult(result, callbackId: command.callbackId)
        }
        
        socket.on("message"){ data , ack in
            print("socket on message:: \(data)")
            
        }
        
        self.socket.onAny {
            print("socket on \($0.event):: \($0.items)")
        }
        
        socket.connect()
        
        //let callerId = command.argumentAtIndex(0) as! String
        //let contact = command.argumentAtIndex(1) as! Int

        let storyboard = UIStoryboard(name: "Chitchat", bundle: nil)
        
        let voiceCallView = storyboard.instantiateViewControllerWithIdentifier("voiceCallView") as! VoiceCallViewController
        
        voiceCallView.hangUpCallback = hangUpCallback
        
        var presentationStyle: UIModalPresentationStyle
        if #available(iOS 8, *) {
            presentationStyle = .OverCurrentContext
        } else {
            presentationStyle = .CurrentContext
        }
        viewController!.modalPresentationStyle = presentationStyle
        voiceCallView.modalPresentationStyle = presentationStyle
        viewController!.modalTransitionStyle = .CoverVertical
        viewController!.presentViewController(voiceCallView, animated: true, completion: nil)
    }
    
    func videoCall(command: CDVInvokedUrlCommand) {
        self.command = command
    }
    
    func waitForEndCall(command: CDVInvokedUrlCommand) {
        self.waitforEndCallCommand = command
    }
    
    func endCall(command: CDVInvokedUrlCommand) {
        self.command = command
        self.socket.disconnect()
        
        print("on endcall from callee")
        
        viewController!.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
        
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:"endCall")
        self.commandDelegate!.sendPluginResult(result, callbackId: self.waitforEndCallCommand.callbackId)
    }
    
    func lineBusy(command: CDVInvokedUrlCommand) {
        self.command = command
    }
    
    func hangUpCallback(){
        
        self.socket.disconnect()
        
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:"endCall")
        self.commandDelegate!.sendPluginResult(result, callbackId: self.waitforEndCallCommand.callbackId)
        
    }

}
