//
//  ZNQRCodeViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/29/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import SwiftQRCode

class ZNQRCodeViewController: UIViewController {

    var qrImageView:UIImageView
    var messageTitle:String = ""
    var url:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "二维码"
        
        view.addSubview(qrImageView)
        
        qrImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.8)
            make.height.equalTo(qrImageView.snp_width)
        }
        self.view.backgroundColor = UIColor.init(red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        qrImageView = UIImageView.init()
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(title:String,url:String){
        self.init(nibName: nil,bundle: nil)
        
        self.messageTitle = title
        self.url = url
        
        let string = messageTitle + "\t\t\t" + url
        
        qrImageView.image = QRCode.generateImage(string, avatarImage: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
