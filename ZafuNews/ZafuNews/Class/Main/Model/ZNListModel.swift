//
//  ZNListModel.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/29/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import Ji

class ZNListModel{
//    从左到右分别是，title，url，日期，点击数
    var listArray = Array<(String,String,String,String)>()
    
    init() {
        let url = "http://news.zafu.edu.cn/articles/3/?page=4"
        let baseURL = "http://news.zafu.edu.cn"
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
//                    继续解析，删去图保留后面的内容
                    var tempTitleArr = title.componentsSeparatedByString("    ")
                    title = tempTitleArr[1]
                }
                
//              解析URL
                if tempStr != nil {
                    urlStr = baseURL + tempStr!
                }
                
//              解析点击数
                let numArr = numStr?.componentsSeparatedByString("点 击 率：")
                num = numArr![1]
                
//              解析日期
                if dates != nil {
                    let index = content?.indexOf(item)
                    date = dates![index!].content!
                }
                
                //            将对应的顺序放入Array中
                listArray.append((title,urlStr,date,num))
            }
        }
        print(listArray)
    }
}
