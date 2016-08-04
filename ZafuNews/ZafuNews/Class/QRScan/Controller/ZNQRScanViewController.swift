//
//  ZNQRScanViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/30/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import SwiftQRCode

class ZNQRScanViewController: UIViewController {
    
    let scanner = QRCode.init(autoRemoveSubLayers: false, lineWidth: 0, strokeColor: UIColor.clearColor(), maxDetectedCount: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "二维码扫描"
        
        scanner.prepareScan(self.view) { (stringValue) in
            self.getURLandPush(stringValue)
        }
        
        
        scanner.scanFrame = view.bounds
        
    }
    
    func getURLandPush(string:String){
        var flag = false
        var url = ""
        
        let strArr = string.componentsSeparatedByString("\t\t\t")
        
        if strArr.count > 1 {
            url = strArr[1]
            if url.componentsSeparatedByString("news.zafu.edu.cn").count >= 0 {
                flag = true
            }
        }
        
        if flag == true {
            let vc = ZNNewInfoViewController.init(searchURL: url)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let alertView = UIAlertController.init(title: "提醒", message: "这个二维码不是本软件生成的，他的内容是\n\(string)", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ac) in
                self.scanner.startScan()
            }))
            
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scanner.startScan()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        scanner.stopScan()
    }
}
