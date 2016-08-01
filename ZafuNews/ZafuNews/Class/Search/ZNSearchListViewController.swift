//
//  ZNSearchListViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 8/1/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNSearchListViewController: UITableViewController,callbackListViewProtocol {

    var listModel:ZNSearchListModel?
    var url:String
    var infoArr = Array<(url:String,title:String)>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.listModel = nil
        self.url = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(url:String){
        self.init(nibName: nil, bundle: nil)
        self.listModel = ZNSearchListModel.init(baseURL: "http://news.zafu.edu.cn", url:url)
        self.title = "搜索"
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (listModel?.listArray.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if (cell == nil) {
            cell = ZNSearchListTableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let tmpCell = cell as! ZNSearchListTableViewCell
        tmpCell.title.numberOfLines = 2
        
        if listModel?.listArray.count != 0 {
            let cellText:(title:String,url:String,date:String) = (listModel?.listArray[indexPath.row])!
            
            tmpCell.title.text = cellText.title
            
            tmpCell.date.text = cellText.date
            tmpCell.url = cellText.url
            
            infoArr.append((cellText.url,cellText.title))
        }
        return tmpCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let info = infoArr[indexPath.row]
        let vc = ZNNewInfoViewController.init(searchURL: info.url)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func finishLoadListView() {
        self.tableView.reloadData()
    }

}
