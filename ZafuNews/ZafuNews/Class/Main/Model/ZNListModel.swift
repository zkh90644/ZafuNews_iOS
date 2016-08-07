//
//  ZNListModel.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/29/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import Ji



protocol callbackListViewProtocol {
    func finishLoadListView()
}

class ZNListModel{
//    从左到右分别是，title，url，日期，点击数
    var listArray = Array<(String,String,String,String)>()
    var delegate:callbackListViewProtocol?
    var currentPage = 1
    var baseURL:String = "http://news.zafu.edu.cn"
    var url:String?
    
    init(){
        
    }
    
    convenience init(url:String,callback:(()->())?) {
        self.init()
        self.url = url
        self.listArray = Array<(String,String,String,String)>()
        let q = dispatch_queue_create("async_queue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(q) {
            self.getMessage(url, callback: callback)
        }
    }
    
    convenience init(url:String){
        self.init(url:url,callback: nil)
    }
    
    convenience init(url:String,listArray:Array<(String,String,String,String)>){
        self.init()
        self.url = url
        self.listArray = listArray
    }
    
    func addNewInfo(callback:(()->())?) {
        currentPage += 1;
        
        let q = dispatch_queue_create("async_queue", DISPATCH_QUEUE_SERIAL)
        let url:String = self.url!+"?page=\(currentPage)"
        
        dispatch_sync(q) { 
            self.getMessage(url, callback: callback)
        }
    }
    
    func reloadData(callback:(()->())?) {
        self.listArray = Array<(String,String,String,String)>()
        let q = dispatch_queue_create("sync_queue", DISPATCH_QUEUE_SERIAL)
        dispatch_async(q) {
            self.getMessage(self.url!, callback: callback)
        }
    }
    
    func getMessage(url:String,callback:(()->())?) {
        let JiCode = Ji.init(htmlURL: NSURL(string: url)!)
        
        let content = JiCode?.xPath("//div[starts-with(@class,'content-right')]/ul/li/a")
        let dates = JiCode?.xPath("//div[starts-with(@class,'content-right')]/ul/li/span")
        
        if content != nil {
            for item in content! {
                
                var title = ""
                var num = ""
                var date = ""
                var urlStr = ""
                
                let titleStr = item.content?.componentsSeparatedByString("\n            ")
                let tempStr = item["href"]
                let numStr = item["title"]
                
                //              解析标题
                if titleStr !=  nil {
                    for item in titleStr! {
                        if item != "" && item != " " {
                            title.appendContentsOf(item)
                        }
                    }
                    //              继续解析，删去图保留后面的内容
                    var tempTitleArr = title.componentsSeparatedByString("    ")
                    title = tempTitleArr[1]
                }
                
                //              删去图字
                let titleArr = title.componentsSeparatedByString("[图]")
                if (titleArr.count == 1){
                    title = titleArr[0]
                }else{
                    title = titleArr[1]
                }
                
                //              解析URL
                if tempStr != nil {
                    urlStr = baseURL + tempStr!
                }
                
                //              解析点击数
                let numArr = numStr?.componentsSeparatedByString("点 击 率：")
                if numArr?.count > 1{
                    num = numArr![1]
                }else{
                    if numArr == nil {
                        num = "0"
                    }else{
                        num = numArr![0]
                    }
                }
                
                //              解析日期
                if dates != nil {
                    let index = content?.indexOf(item)
                    date = dates![index!].content!
                }
                
                //            将对应的顺序放入Array中
                self.listArray.append((title,urlStr,date,num))
            }
            
            
            let mainQueue = dispatch_get_main_queue()
            
            dispatch_async(mainQueue, {
                if callback != nil{
                    callback!()
                }
                self.delegate?.finishLoadListView()
            })

        }
    }
}
