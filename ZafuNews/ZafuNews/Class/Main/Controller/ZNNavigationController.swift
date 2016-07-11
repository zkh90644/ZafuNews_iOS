//
//  ZNNavigationController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/11/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarStyle()
        // Do any additional setup after loading the view.
    }

    func setNavigationBarStyle() {
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = defaultColor
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
    
}
