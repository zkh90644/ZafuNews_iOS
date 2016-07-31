//
//  ZNSearchViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/31/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ZNSearchViewController: UIViewController {

    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet var tapBackground: UITapGestureRecognizer!
    
    @IBOutlet weak var search: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.search.hidden = true
        
        self.cancel.addTarget(self, action: #selector(pressCancel), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.search.addTarget(self, action: #selector(pressSearch), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tapBackground.addTarget(self, action: #selector(tapBackgroundAction))
        
        textInput.rac_textSignal().subscribeNext { (string) in
            
            if string as! String != ""{
                self.cancel.hidden = true
                self.search.hidden = false
                
            }else{
                self.cancel.hidden = false
                self.search.hidden = true
            
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
    }

    func pressCancel() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func pressSearch() {
        print(self.textInput.text)
    }

    func tapBackgroundAction() {
        if self.textInput.isFirstResponder() {
            if self.textInput.canResignFirstResponder() {
                self.textInput.resignFirstResponder()
            }
        }
    }

}
