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
    
    var labelArray = Array<UILabel>()
    var imageViewArray = Array<UIImageView>()
    
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
    
    func finishLabel(){
        var lastView:UILabel? = nil
        
        for message in messageModal.labelArr {
    //            let index = messageModal.labelArr.indexOf(message)
            let tempLabel = UILabel()
            
            basicView.addSubview(tempLabel)
            
            tempLabel.text = message
            tempLabel.numberOfLines = 0
            
            if lastView == nil {
                tempLabel.snp_makeConstraints(closure: { (make) in
                    make.width.equalTo(self).multipliedBy(0.9)
                    make.top.equalTo(self).offset(5)
                    make.centerX.equalTo(self)
                })
            }else{
                tempLabel.snp_makeConstraints(closure: { (make) in
                    make.width.equalTo(lastView!)
                    make.top.equalTo(lastView!.snp_bottom)
                    make.centerX.equalTo(self)
                })
            }
            
            lastView = tempLabel
            labelArray.append(tempLabel)
        }
        
        lastView?.snp_makeConstraints(closure: { (make) in
            make.bottom.equalTo(self)
        })
    }
    
    func changImage(count: Int) {
//        var flag = false
//        if messageModal.imageDic.count == count {
////            对key进行排序，方便后面使用
//            let keys = messageModal.imageDic.keys
//            var keyArray = keys.sort()
//            
//            var lastImage:UIImageView? = nil
//            var num = 0
//            for item in labelArray {
//                if item.text == "" {
//                    let ImageName = keyArray[num]
//                    let Image = messageModal.imageDic[ImageName]
//                    let imageView = UIImageView.init(image: Image!)
//                    
//                    imageView.snp_makeConstraints(closure: { (make) in
//                        <#code#>
//                    })
//                }
//                num += 1
//            }
//        }
    }

}
