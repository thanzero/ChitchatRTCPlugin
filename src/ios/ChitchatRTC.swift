//
//  ChitchatRTC.swift
//  ChitchatRTC
//
//  Created by Prathan B.
//

import UIKit

@objc(ChitchatRTC) class ChitchatRTC: CDVPlugin {

    var command = CDVInvokedUrlCommand()

    func freeCall(command: CDVInvokedUrlCommand) {
        self.command = command

        //let callerId = command.argumentAtIndex(1) as! String
        //let contact = command.argumentAtIndex(2) as! Int

        //let sourceImages = command.argumentAtIndex(0) as! [[String: AnyObject]]
        
        let storyboard = UIStoryboard(name: "Chitchat", bundle: nil)

        /*
        let navCtrl = storyboard.instantiateViewControllerWithIdentifier("galleryNavigationController") as! UINavigationController
        let galleryNavCtrl = navCtrl.childViewControllers[0] as! GalleryViewController
        galleryNavCtrl.closeCallback = modalDidClose
        galleryNavCtrl.deleteCallback = modalDidCloseToDeleteImageAtIndex
        galleryNavCtrl.initialIndex = index
        galleryNavCtrl.images = images
        
        var presentationStyle: UIModalPresentationStyle
        if #available(iOS 8, *) {
            presentationStyle = .OverCurrentContext
        } else {
            presentationStyle = .CurrentContext
        }
        viewController!.modalPresentationStyle = presentationStyle
        navCtrl.modalPresentationStyle = presentationStyle
        viewController!.modalTransitionStyle = .CoverVertical
        viewController!.presentViewController(navCtrl, animated: true, completion: nil)
        */
    }

}
