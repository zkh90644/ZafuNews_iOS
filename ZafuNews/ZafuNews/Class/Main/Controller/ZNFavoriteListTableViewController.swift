//
//  ZNFavoriteListTableViewController.swift
//  
//
//  Created by zkhCreator on 8/6/16.
//
//

import UIKit
import SQLite

class ZNFavoriteListTableViewController: UITableViewController {

    var db = (UIApplication.sharedApplication().delegate as! AppDelegate).db
    var array = Array<(String,String)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的收藏"
        
        self.connectToDB()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("favorite")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("favorite")
    }
    
    func connectToDB() {
        let table = Table("favorite")
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")
        let url = Expression<String>("url")
        
        try! db!.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(title)
            t.column(url)
        })
        
        for item in try! db!.prepare(table) {
            self.array.append((item[title],item[url]))
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellName = "favorite"
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier(cellName)
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellName)
        }
        
        cell?.textLabel?.text = array[indexPath.row].0
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let table = Table("favorite")
        let url = Expression<String>("url")
        
        let deleteFilter = table.filter(url == self.array[indexPath.row].1)
        try! db?.run(deleteFilter.delete())
        
        self.array.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let info = array[indexPath.row]
        
        let nextVC = ZNNewInfoViewController(searchURL: info.1)
        nextVC.title = info.0
        self.navigationController!.pushViewController(nextVC, animated: true)
    }

}
