//
//  FreeCallViewController.swift
//  ChitChat
//
//  Created by Prathan B. on 1/27/16.
//
//

import UIKit


class FreeCallViewController: UIViewController {
    
    
    var closeCallback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneClicked(sender: UIBarButtonItem) {
        print("clicked!")
        dismissViewControllerAnimated(true, completion: closeCallback)
    }
    
    @IBAction func Close(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: closeCallback)
        
    }
}