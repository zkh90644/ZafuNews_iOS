//
//  ZNLeftBarContentView.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/10/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

let ListDic = ["save":"我的收藏","clean":"清除缓存","about":"关于我们"]


class ZNLeftBarContentView: UIView {
    
    var weatherView = ZNWeatherView()
    var itemListView = UIScrollView()
    

    override init(frame: CGRect) {
        super.init(frame:frame)
        initView()
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.addSubview(weatherView)
        self.addSubview(itemListView)
        
        itemListView.backgroundColor = UIColor.init(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1)
        
        weatherView.snp_makeConstraints { (make) in
            make.width.top.left.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.3)
        }
        
        itemListView.snp_makeConstraints { (make) in
            make.width.bottom.left.equalTo(self)
            make.top.equalTo(weatherView.snp_bottom)
        }
        
        
        var lastButton = UIButton.init()
        //添加到list
        for (key,value) in ListDic {
            let button = ZNLeftListCell.init(image: UIImage.init(named: key)!, name: value)
            itemListView.addSubview(button)
        
            if (key,value) == ListDic.first! {
                button.snp_makeConstraints(closure: { (make) in
                    make.height.equalTo(itemListView).multipliedBy(0.1)
                    make.left.top.width.equalTo(itemListView)
                })
            }else{
                button.snp_makeConstraints(closure: { (make) in
                    make.height.equalTo(itemListView).multipliedBy(0.1)
                    make.top.equalTo(lastButton.snp_bottom)
                    make.left.width.equalTo(lastButton)
                })
            }
            
            lastButton = button
        }
        
    }
}
