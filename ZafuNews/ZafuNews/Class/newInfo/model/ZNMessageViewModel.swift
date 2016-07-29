//
//  ZNMessageViewModel.swift
//  
//
//  Created by zkhCreator on 7/28/16.
//
//

import UIKit
import SnapKit

class ZNMessageViewModel: UIScrollView,messageCallBackProtocol {

    var messageModal = ZNMessageInfo()
    
    var viewArray = Array<UIView>()
    
    var basicView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(baseURL:String,searchURL:String) {
        self.init(frame:CGRectZero)
        
        messageModal = ZNMessageInfo.init(baseURL: baseURL, searchURL: searchURL)
        messageModal.delegate = self
        
        self.addSubview(basicView)
        basicView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    
// MARK:delegate
    func finishLabel(){
        self.setUpImageAndLabel()
    }
    
    func changImage(count: Int) {
        if count == messageModal.imageDic.count {
            //获得图片，并按照key排序
            let keys = messageModal.imageDic.keys
            var keyArr = keys.sort()
            
            for item in viewArray {
                if item.isKindOfClass(UIImageView) {
                    let image = messageModal.imageDic[keyArr.popLast()!]
                    let imageView = item as! UIImageView
                    imageView.image = image
                    
                    imageView.snp_updateConstraints(closure: { (make) in
                        make.height.equalTo(imageView.snp_width).multipliedBy((image?.size.height)! / (image?.size.width)!)
                    })
                }
            }
        }
    }
    
// MARK:setUpView
    func setUpImageAndLabel() {
        
        //        设置标题
        let titleLabel = UILabel.init()
        basicView.addSubview(titleLabel)
        titleLabel.text = messageModal.headerStr
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.init(name: (titleLabel.font?.fontName)!, size: 20)
        
        titleLabel.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(self).multipliedBy(0.9)
            make.top.equalTo(self).offset(10)
            make.centerX.equalTo(self)
        })
        viewArray.append(titleLabel)
        
        
        //        设置作者
        let editorLabel = UILabel.init()
        basicView.addSubview(editorLabel)
        editorLabel.numberOfLines = 0
        editorLabel.text = messageModal.editor
        editorLabel.textAlignment = NSTextAlignment.Center
        
        editorLabel.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(self).multipliedBy(0.9)
            make.top.equalTo(titleLabel.snp_bottom).offset(20)
            make.centerX.equalTo(self)
        })
        viewArray.append(editorLabel)
        
        var lastView:UIView? = editorLabel
        for message in messageModal.labelArr {
            //            判断是否应该放入图片
            if message != "" {
                let tempLabel = UILabel()
                
                basicView.addSubview(tempLabel)
                
                tempLabel.text = message
                tempLabel.numberOfLines = 0
                
                if lastView == nil {
                    tempLabel.snp_makeConstraints(closure: { (make) in
                        make.width.equalTo(self).multipliedBy(0.9)
                        make.top.equalTo(self).offset(10)
                        make.centerX.equalTo(self)
                    })
                }else{
                    tempLabel.snp_makeConstraints(closure: { (make) in
                        make.width.equalTo(self).multipliedBy(0.9)
                        make.top.equalTo(lastView!.snp_bottom).offset(10)
                        make.centerX.equalTo(self)
                    })
                }
                
                lastView = tempLabel
                viewArray.append(tempLabel)
            }else{
                let tempImage = UIImageView()
                basicView.addSubview(tempImage)
                
                tempImage.snp_makeConstraints(closure: { (make) in
                    make.width.equalTo(self).multipliedBy(0.6)
                    make.top.equalTo(lastView!.snp_bottom).offset(10)
                    make.centerX.equalTo(self)
                })
                lastView = tempImage
                viewArray.append(tempImage)
            }
        }
        
        lastView?.snp_makeConstraints(closure: { (make) in
            make.bottom.equalTo(self).offset(-10)
        })
    }
}
