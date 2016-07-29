//
//  ZNPopView.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/27/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNPopView: UIView {
    
    var qrCode:UIButton = UIButton()
    var save:UIButton = UIButton()
    var share:UIButton = UIButton()
    var picture:UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        share = self.setButton(UIImage.init(named: "Share")!, title: "分享")
        qrCode = self.setButton(UIImage.init(named: "QCCode")!, title: "生成二维码")
        save = self.setButton(UIImage.init(named: "saveLocation")!, title: "保存到本地")
        picture = self.setButton(UIImage.init(named: "Out")!, title:"导出成图片")
        
        self.addSubview(qrCode)
        self.addSubview(save)
        self.addSubview(share)
        self.addSubview(picture)
        
        qrCode.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        save.snp_makeConstraints { (make) in
            make.width.left.equalTo(self)
            make.height.equalTo(qrCode)
            make.top.equalTo(qrCode.snp_bottom)
        }
        share.snp_makeConstraints { (make) in
            make.width.left.equalTo(self)
            make.height.equalTo(save)
            make.top.equalTo(save.snp_bottom)
        }
        picture.snp_makeConstraints { (make) in
            make.width.left.equalTo(self)
            make.height.equalTo(share)
            make.top.equalTo(share.snp_bottom)
        }
        
        
        self.backgroundColor = defaultColor
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 2
    }
    
    func setButton(image:UIImage,title:String) -> UIButton {
        let button = UIButton.init(type: UIButtonType.Custom)
        
        button.setImage(image, forState: UIControlState.Normal)
        button.setTitle(title, forState: UIControlState.Normal)
        
        button.imageView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(button).offset(5)
            make.top.equalTo(button).offset(5)
            make.bottom.equalTo(button.snp_bottom).offset(-5)
            make.width.equalTo(button.snp_height).offset(-10)
        })
        
        button.titleLabel?.snp_makeConstraints(closure: { (make) in
            
        })
        
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
