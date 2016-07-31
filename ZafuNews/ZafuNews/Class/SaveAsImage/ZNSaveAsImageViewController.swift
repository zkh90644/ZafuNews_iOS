//
//  ZNSaveAsImageViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/30/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNSaveAsImageViewController: UIViewController {

    let scrollView = UIScrollView()
    var viewArr:Array<UIView>?
    var framsArray:Array<CGRect>?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewArr:Array<UIView>,frames:Array<CGRect>){
        self.init(nibName: nil, bundle: nil)
        self.viewArr = viewArr
//        self.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.drawImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(scrollView)
        
        scrollView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.bottom.equalTo(self.view).offset(-10)
        }
        
        let imageView = UIImageView.init(image: drawImage())
        self.scrollView.addSubview(imageView)
        
    }
    
    func drawImage() -> UIImage {
        let image = ZNMessageInfoView.init(viewArr: self.viewArr!)
        image.frame = CGRectMake(0, 0, self.view.bounds.width * 0.8, 1400)
        return image.image
    }
    

}
