//
//  ZNInfoListViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/11/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SQLite

protocol pushToInfoNewDelegate {
    func pushToNextViewController(title:String,url:String)
}

class ZNInfoListViewController: UITableViewController,callbackListViewProtocol {
    
    var delegate:pushToInfoNewDelegate?

    let ZNTableCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    var listModel:ZNListModel?
    var url:String
    var infoArr = Array<(url:String,title:String,count:String)>()
    let db = (UIApplication.sharedApplication().delegate as! AppDelegate).db
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.listModel = nil
        self.url = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init(url:String,title:String){
        self.init(nibName: nil, bundle: nil)
        
        self.url = url
        self.title = title
        
        let cacheTable = Table("cache")
        let title = Expression<String>("title")
        let urlString = Expression<String>("url")
        let count = Expression<String>("count")
        let date = Expression<String>("date")
        let category = Expression<String>("category")

        //        将result组合成array
        let result = try! self.db?.prepare(cacheTable.filter(category == self.title!))
        let countNum = try! self.db?.scalar(cacheTable.filter(category == self.title!).count)
        
        if countNum > 0 {
            //        将选出的内容放置到数组中去
            var arr = Array<(String,String,String,String)>()
            for item in result! {
                arr.append((item[title],item[urlString],item[date],item[count]))
            }
            self.listModel = ZNListModel.init(url: url, listArray: arr)
            
        }else{
            self.listModel = ZNListModel.init(url:url)
        }
        
        self.tableView.es_addPullToRefresh {
            [weak self] in
            self?.listModel?.reloadData({
                self?.tableView.es_stopPullToRefresh(completion: true)
            })
        }
        
        self.tableView.es_addInfiniteScrolling {
            [weak self] in
            
            self?.listModel?.addNewInfo({
                self?.tableView.es_stopLoadingMore()
            })
            
        }
    }
    
    convenience init(url:String){
        self.init(nibName: nil, bundle: nil)
        
        self.listModel = ZNListModel.init(url:url)
        
        self.tableView.es_addPullToRefresh {
            [weak self] in
            self?.listModel?.reloadData({
                self?.tableView.es_stopPullToRefresh(completion: true)
            })
        }
        
        self.tableView.es_addInfiniteScrolling { 
            [weak self] in
            
            self?.listModel?.addNewInfo({
                self?.tableView.es_stopLoadingMore()
            })
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10
        
        listModel?.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listModel?.listArray.count)!
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if (cell == nil) {
            cell = ZNTableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let tmpCell = cell as! ZNTableViewCell
        tmpCell.title.numberOfLines = 2
        
        if listModel?.listArray.count != 0 {
            let cellText:(title:String,url:String,date:String,num:String) = (listModel?.listArray[indexPath.row])!
            
            tmpCell.title.text = cellText.title
                
            tmpCell.date.text = cellText.date
            tmpCell.number.text = cellText.num
            tmpCell.url = cellText.url
            
            infoArr.append((cellText.url,cellText.title,count:cellText.num))
        }
        return tmpCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let info = infoArr[indexPath.row]
        
        self.delegate?.pushToNextViewController(info.title,url: info.url)
    }
    
    
    //MARK:Delegate
    func finishLoadListView() {
//        if self.tableView.numberOfRowsInSection(0) < listModel?.listArray.count {
//            let startCount = self.tableView.numberOfRowsInSection(0)
//            let endCount = listModel?.listArray.count
//            
//            var indexPathArr:Array<NSIndexPath> = []
//            
//            for row in startCount ..< endCount! {
//                indexPathArr.append(NSIndexPath.init(forRow: row, inSection: 0))
//            }
//            
//            self.tableView.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: UITableViewRowAnimation.Top)
////            self.tableView.reloadRowsAtIndexPaths(indexPathArr, withRowAnimation: UITableViewRowAnimation.Bottom)
//        }else{
            self.tableView.reloadData()
//        }
        self.addValueToDB()
    }
    
    func addValueToDB() {
        let queue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_SERIAL)
        let cacheTable = Table("cache")
        let url = Expression<String>("url")
        let title = Expression<String>("title")
        let count = Expression<String>("count")
        let date = Expression<String>("date")
        let category = Expression<String>("category")
        let content = Expression<Blob>("content")
        
        dispatch_async(queue) {
            for item in (self.listModel?.listArray)!{
                let tempItem = item as (String,String,String,String)
                //    从左到右分别是，title，url，日期，点击数

                let countNum = self.db?.scalar(cacheTable.filter(url == tempItem.1).count)
                let emptyArray = Array<UIView>()
                let data = NSKeyedArchiver.archivedDataWithRootObject(emptyArray)
                let blob = data.datatypeValue
                
                if countNum == 0{
                    try! self.db?.run(cacheTable.insert([title<-tempItem.0,url<-tempItem.1,date<-tempItem.2,count<-item.3,category<-self.title!,content<-blob]))
                }else{
                    try! self.db?.run(cacheTable.filter(url == tempItem.1).update([count<-item.3]))
                }
            }
        }
    }
    
}
