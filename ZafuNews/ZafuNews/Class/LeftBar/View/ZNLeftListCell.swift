//
//  ZNLeftListCell.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/10/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNLeftListCell: UIButton {
    
    var cellImage = UIImage()
    var cellName = NSString()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image:UIImage, name:NSString) {
        self.init(frame: CGRectZero)
        cellImage = image
        cellName = name
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        let cellImageView = UIImageView.init(image: cellImage)
        let cellLabel = UILabel.init()
        cellLabel.text = cellName as String
        cellLabel.font = UIFont.systemFontOfSize(16)
        cellLabel.textAlignment = NSTextAlignment.Left
        cellLabel.textColor = UIColor.init(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1)
        
        self.addSubview(cellImageView)
        self.addSubview(cellLabel)
        
        cellImageView.snp_makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(cellImageView.snp_height)
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        
        cellLabel.snp_makeConstraints { (make) in
            make.height.centerY.equalTo(self)
            make.left.equalTo(cellImageView.snp_right).offset(40)
            make.right.equalTo(self)
        }
        
    }

}
