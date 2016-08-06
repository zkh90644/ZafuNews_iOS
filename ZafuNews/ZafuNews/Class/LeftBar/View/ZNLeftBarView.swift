//
//  ZNLeftBarView.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/10/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNLeftBarView: UIView {
    
    var backgroundView = UIView()
    var leftView = ZNLeftBarContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.addSubview(backgroundView)
        self.addSubview(leftView)
        
//        黑色背景init
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(HideView))
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(HideView))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.addGestureRecognizer(swipeGesture)
        leftView.addGestureRecognizer(swipeGesture)
        
//        左侧View init
        leftView.backgroundColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1)
        
        backgroundView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        leftView.snp_makeConstraints { (make) in
            make.height.top.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.7)
            make.right.equalTo(self.snp_left)
        }
        
        self.alpha = 0
    }
    
    func showView() {
        self.alpha = 1
        
        leftView.snp_remakeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.7)
            make.left.height.top.equalTo(self)
        }
        
        UIView.animateWithDuration(0.5) {
            self.layoutIfNeeded()
            self.backgroundView.alpha = 0.6
        }
    }
    
    func HideView() {
        
        leftView.snp_remakeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.7)
            make.height.top.equalTo(self)
            make.right.equalTo(self.snp_left)
        }
        
        UIView.animateWithDuration(0.5, animations: { 
            self.layoutIfNeeded()
            self.backgroundView.alpha = 0
        }) { (finished) in
            if(finished){
                self.alpha = 0
            }
        }
    }
}
