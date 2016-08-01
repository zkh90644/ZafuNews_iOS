//
//  ZNSearchViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/31/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ZNSearchViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet var tapBackground: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancel.addTarget(self, action: #selector(pressCancel), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tapBackground.addTarget(self, action: #selector(tapBackgroundAction))
        
        self.textInput.keyboardType = UIKeyboardType.WebSearch
        self.textInput.enablesReturnKeyAutomatically = true
        self.textInput.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    func pressCancel() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func pressSearch() {
        let url = "http://news.zafu.edu.cn/search/?keyword=" + self.textInput.text!
        let vc = ZNSearchListViewController.init(url: url)
        
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func tapBackgroundAction() {
        if self.textInput.isFirstResponder() {
            if self.textInput.canResignFirstResponder() {
                self.textInput.resignFirstResponder()
            }
        }
    }

//    键盘delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.pressSearch()
        
        return true
    }
    
}
