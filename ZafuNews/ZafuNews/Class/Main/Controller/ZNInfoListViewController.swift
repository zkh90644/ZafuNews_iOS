//
//  ZNInfoListViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/11/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

protocol pushToInfoNewDelegate {
    func pushToNextViewController(title:String)
}

class ZNInfoListViewController: UITableViewController {
    
    var delegate:pushToInfoNewDelegate?

    let ZNTableCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if (cell == nil) {
            cell = ZNTableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let tmpCell = cell as! ZNTableViewCell
        tmpCell.title.numberOfLines = 2
        
        tmpCell.title.text = "helloworldhelloworldhelloworhelloworldhelloworldhelloworhelloworldhelloworldhelloworhelloworldhelloworldhelloworhelloworldhelloworldhelloworhelloworldhelloworldhellowor"
        
        tmpCell.date.text = "2016-9-12"
        tmpCell.number.text = "2333"
        
        return tmpCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.delegate?.pushToNextViewController("helloworld")
    }
    
}
