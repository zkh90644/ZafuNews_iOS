//
//  ZNNewInfoViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/26/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import SQLite

class ZNNewInfoViewController: UIViewController {

    let alertView = ZNPopView()
    var messageViewModel = ZNMessageViewModel()
    var url = ""
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(searchURL: String,category:String){
        self.init(nibName: nil, bundle: nil)
        self.url = searchURL
        self.messageViewModel = ZNMessageViewModel(baseURL: "http://news.zafu.edu.cn",searchURL: searchURL)
        self.category = category
    }
    
    convenience init(searchURL:String){
        self.init(searchURL:searchURL,category: "无分类")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
//        设置Navigation
        self.view.backgroundColor = UIColor.init(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        let back = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(showAndHidePopView))
        
//        设置内容界面
        self.view.addSubview(self.messageViewModel)
        messageViewModel.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
//        加入下拉栏
        self.view.addSubview(alertView)
        alertView.hidden = true
        alertView.snp_makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(10)
        }
        
        
//        addAction
        self.alertView.qrCode.addTarget(self, action: #selector(clickQRButton), forControlEvents: UIControlEvents.TouchUpInside)
        self.alertView.picture.addTarget(self, action: #selector(saveAsImage), forControlEvents: UIControlEvents.TouchUpInside)
        self.alertView.save.addTarget(self, action: #selector(myFavorite), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func showAndHidePopView() {
        alertView.hidden = !alertView.hidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //    popButtonAction
    func clickQRButton() {
        let viewController = ZNQRCodeViewController.init(title: self.title!, url: self.url)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func saveAsImage() {
        let BasicViewHeight = self.messageViewModel.basicView.frame.height
        let BasicViewWidth = self.view.width * 1
        UIGraphicsBeginImageContext(CGSizeMake(BasicViewWidth, BasicViewHeight))
        
        var drawPointY:CGFloat = 10
        
        for view in messageViewModel.viewArray {
            if view.isKindOfClass(UILabel) {
                let image = (view as! UILabel).convertToImage()
                let left = (BasicViewWidth - image.size.width) / 2
                image.drawAtPoint(CGPointMake(left, drawPointY))
                drawPointY += image.size.height
                drawPointY += 10
            }else if view.isKindOfClass(UIImageView){
                let image = (view as! UIImageView).image
                
                if image != nil {
                    let left = (BasicViewWidth - image!.size.width) / 2
                    
                    image?.drawAtPoint(CGPointMake(left, drawPointY))
                    drawPointY += (image?.size.height)!
                    drawPointY += 10

                }
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ZNNewInfoViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let alertVC = UIAlertController.init(title: "提醒", message: "已经成功保存", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }else{
            let alertVC = UIAlertController.init(title: "提醒", message: "保存失败", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    func myFavorite() {
        let db = (UIApplication.sharedApplication().delegate as! AppDelegate).db
        
        let table = Table("favorite")
        let title = Expression<String>("title")
        let url = Expression<String>("url")
        
        if self.title == nil {
            self.title = "无标题"
        }
        
        let count = try db?.scalar(table.filter(url == self.url).count)
        if count == 0 {
            try! db?.run(table.insert(title <- self.title!,url <- self.url))
            let alertVC = UIAlertController.init(title: "提醒", message: "您已经收藏了这篇文章", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }else{
            let deleteFilter = table.filter(url == self.url)
            try! db?.run(deleteFilter.delete())
            let alertVC = UIAlertController.init(title: "提醒", message: "您取消收藏了这篇文章", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }

}
