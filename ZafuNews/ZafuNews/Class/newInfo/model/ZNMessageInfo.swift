//
//  ZNMessageInfo.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/28/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import Ji
import AlamofireImage
import Alamofire

extension String {
    func urlEncode() -> String? {
        let unreserved = "!=:-._~/?"
        let allowed = NSMutableCharacterSet.alphanumericCharacterSet()
        allowed.addCharactersInString(unreserved)
        return stringByAddingPercentEncodingWithAllowedCharacters(allowed)
    }
}

//该协议用来修改上一个VC的界面
protocol messageCallBackProtocol {
    func changImage(count:Int)
    func finishLabel()
}

class ZNMessageInfo{
    var delegate:messageCallBackProtocol?
    var headerStr = ""
    var editor = ""
    var labelArr = Array<String>()
    var imageDic = Dictionary<String,UIImage>()
    
    init(baseURL:String,searchURL:String) {
        if baseURL != "" && searchURL != "" {
            self.setUpData(baseURL, searchURL: searchURL)
        }
    }

    convenience init(){
        self.init(baseURL:"",searchURL:"")
    }
    
    func setUpData(baseURL:String,searchURL:String) {
        
        let queue = dispatch_queue_create("SerialDispatchQueue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(queue) { 

            var longStr = ""

            let ji = Ji(htmlURL: NSURL(string: searchURL)!)
            
            //        解析界面
            let header = ji?.xPath("//h1[starts-with(@class,'title2')]")
            let from = ji?.xPath("//h1[starts-with(@class,'info')]")
            let info = ji?.xPath("//div[starts-with(@id, 'article_content')]/p")
            let images = ji?.xPath("//div[starts-with(@id, 'content-main')]/div/div/p/a/img")
            
            //        标题设置
            if header != nil {
                if header![0].content != nil {
                    self.headerStr = header![0].content!
                }
            }
            
            //        发稿人设置
            if from != nil {
                if from![0].content != nil {
                    let fromArr = from![0].content!.componentsSeparatedByString("\r\n       ")
                    for i in fromArr {
                        self.editor.appendContentsOf(i)
                    }
                }
            }
            
            //        文本内容处理
            if info != nil {
                for i in info! {
                    if i.content != nil {
                        longStr.appendContentsOf(i.content!)
                    }
                }
            }
            
            
            self.labelArr = longStr.componentsSeparatedByString("\r\n\t")
            if self.labelArr[0] == "" {
                self.labelArr.removeAtIndex(0)
            }
            
            let mainQueue = dispatch_get_main_queue()
            dispatch_async(mainQueue, { 
                self.delegate?.finishLabel()
            })
            
            //        对图片进行加载
            if images != nil {
                
                self.imageDic = Dictionary<String,UIImage>.init(minimumCapacity: 0)
                
                for i in images! {
                    
                    let url = baseURL + i["src"]!
                    
                    Alamofire.request(.GET, url.urlEncode()!).responseImage { response in
                        if let image = response.result.value {
                            self.imageDic.updateValue(image, forKey: url)
                            self.delegate?.changImage((images?.count)!)
                        }
                    }
                }
            }
            
        }
    }
}
