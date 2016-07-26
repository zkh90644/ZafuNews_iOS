//
//  ZNNewInfoViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/26/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNNewInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        
        let back = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.navigationItem.backBarButtonItem = back
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
