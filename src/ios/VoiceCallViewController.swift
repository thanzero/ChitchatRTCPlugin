//
//  VoiceCallViewController.swift
//  ChitChat
//
//  Created by Prathan B. on 1/27/16.
//
//

import UIKit


class VoiceCallViewController: UIViewController {
    
    
    var hangUpCallback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func hangUp(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: hangUpCallback)
    }
}