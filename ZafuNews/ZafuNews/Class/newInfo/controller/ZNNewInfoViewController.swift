//
//  ZNNewInfoViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/26/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNNewInfoViewController: UIViewController {

    let alertView = ZNPopView()
    let messageViewModel = ZNMessageViewModel(baseURL: "http://news.zafu.edu.cn", searchURL: "http://news.zafu.edu.cn/articles/3/29801/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }
    
    func setView() {
//        设置Navigation
        self.view.backgroundColor = UIColor.init(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        let back = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(showAndHidePopView))
        
//        设置内容界面
        self.view.addSubview(self.messageViewModel)
        messageViewModel.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        
        //        加入下拉栏
        self.view.addSubview(alertView)
        alertView.hidden = true
        alertView.snp_makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(10)
        }

    }
    
    func showAndHidePopView() {
        alertView.hidden = !alertView.hidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
