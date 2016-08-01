//
//  ZNSearchListModel.swift
//  ZafuNews
//
//  Created by zkhCreator on 8/1/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import Ji

class ZNSearchListModel {
    
    //    从左到右分别是，title，url，日期
    var listArray = Array<(String,String,String)>()
    var delegate:callbackListViewProtocol?
    
    init(baseURL:String,url:String) {
        
        let q = dispatch_queue_create("async_queue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(q) {
            let JiCode = Ji.init(htmlURL: NSURL(string: url)!)
            
            let content = JiCode?.xPath("//div[starts-with(@class,'content-right')]/ul/li/a")
            let dates = JiCode?.xPath("//div[starts-with(@class,'content-right')]/ul/li/span")
            
            if content != nil {
                for item in content! {
                    
                    var title = ""
                    var date = ""
                    var urlStr = ""
                    
                    let tempStr = item["href"]
                    let titleStr = item["title"]
                    
//                    解析标题
                    if titleStr !=  nil{
                        title = titleStr!
                    }
                    
//                    解析URL地址
                    if tempStr != nil{
                        urlStr = baseURL + tempStr!
                    }
                    
//                    解析日期
                    if dates != nil {
                        let index = content?.indexOf(item)
                        date = dates![index!].content!
                    }
                    
                    //            将对应的顺序放入Array中
                    self.listArray.append((title,urlStr,date))
                }
            }
            
            let mainQueue = dispatch_get_main_queue()
            
            dispatch_async(mainQueue, {
                self.delegate?.finishLoadListView()
            })
        }
    }
}
