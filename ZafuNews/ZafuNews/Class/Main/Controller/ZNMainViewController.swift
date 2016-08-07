//
//  ZNMainViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/9/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SQLite

let defaultColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1)
let key = "71bbf3830b814ff19f1698ae02b2dfe0"

class ZNMainViewController: UIViewController,coreTabViewDelegate,pushToInfoNewDelegate{

    let navVC = ZNNavigationController.init()
    let leftBarVC = ZNLeftBarViewController.init()
    
    var switchView = coreTabPage()
    let mainVC = UIViewController()
    
    lazy var vcArray:Array<UIViewController> = Array<UIViewController>()
    
    let db = (UIApplication.sharedApplication().delegate as! AppDelegate).db
    
//  MARK:生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchView.delegate = self;

        initTitleView()
        initLeftBarView()
        
        for item in self.leftBarVC.leftBarView.leftView.buttonArr {
            let button = item as! ZNLeftListCell
            if button.cellName == "关于我们" {
                button.addTarget(self, action: #selector(aboutMe), forControlEvents: UIControlEvents.TouchUpInside)
            }
            if button.cellName == "我的收藏" {
                button.addTarget(self, action: #selector(pushToFavorite), forControlEvents: UIControlEvents.TouchUpInside)
            }
            if button.cellName == "清除缓存" {
                button.addTarget(self, action: #selector(deleteCache), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = preferredStatusBarStyle()
    }
    
//    MARK:界面设计
    func initTitleView() {
        
//        设置statusBar的颜色
        UIApplication.sharedApplication().statusBarStyle = preferredStatusBarStyle()
        
//        设置rootViewController
        navVC.pushViewController(mainVC, animated: false)
        initMainVC()
        
//        设置title
        let titleDic = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navVC.navigationBar.titleTextAttributes = titleDic
        navVC.navigationBar.topItem?.title = "农大新闻网"
        
        addChildViewController(navVC)
        view.addSubview(navVC.view)
        removeNavigationBarBlackLine()
        
        setTitleButton()
    }

//    设置左边界面
    func initLeftBarView() {
        self.addChildViewController(self.leftBarVC)
        self.view.addSubview(self.leftBarVC.leftBarView)
        
        self.leftBarVC.leftBarView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    func initMainVC() {
        
        let pathFile = NSBundle.mainBundle().pathForResource("WebUrlAndTitle", ofType: "plist")
        let arr = NSArray.init(contentsOfFile: pathFile!)
        
        for item in arr! {
            let dic = item as! NSDictionary
            let vc = ZNInfoListViewController(url: (dic["URL"] as! String),title:dic["title"] as! String)
            self.vcArray.append(vc)
        }
        
        for item in self.vcArray {
            let tmp = item as! ZNInfoListViewController
            tmp.delegate = self
        }
        
        mainVC.view.addSubview(switchView)
        var frame = UIScreen.mainScreen().bounds
        frame = CGRectMake(0, 0, frame.width, frame.height - (navVC.navigationBar.height+switchView.tabHight+20))   //此处20是status高度
        switchView.frame = CGRectMake(0, 0, frame.width, frame.height)
        switchView.tabBackground = defaultColor

        switchView.BuildIn()
        
    }
    
//    设置导航栏按钮
    func setTitleButton() {
        //        设置左侧按钮
        let leftButton = getButton(UIImage.init(named: "list")!)
        leftButton.addTarget(self, action: #selector(leftViewAction), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem.init(customView: leftButton)
        navVC.navigationBar.topItem?.leftBarButtonItem = leftItem
        
        //        设置右边按钮
        let scanButton = getButton(UIImage.init(named: "scan")!)
        scanButton.addTarget(self, action: #selector(pushToQRScan), forControlEvents: UIControlEvents.TouchUpInside)
        let scanBarButton = UIBarButtonItem.init(customView: scanButton)
        
        let searchButton = getButton(UIImage.init(named: "search")!)
        searchButton.addTarget(self, action: #selector(pressSearchButton), forControlEvents: UIControlEvents.TouchUpInside)
        let searchBarButton = UIBarButtonItem.init(customView: searchButton)
        
        navVC.navigationBar.topItem?.rightBarButtonItems = [searchBarButton,scanBarButton]

    }
    
//  MARK: 按钮的action
    func leftViewAction() {
        self.leftBarVC.leftBarView.showView()
    }
    
    func pushToQRScan() {
        let qrscanVC = ZNQRScanViewController()
        self.navVC.pushViewController(qrscanVC, animated: true)
    }
    
    func pressSearchButton() {
        let vc = ZNSearchViewController()
        self.navVC.pushViewController(vc, animated: false)
    }

    func aboutMe() {
        let alertVC = UIAlertController.init(title: "About Me", message: "This App code by zkhCreator\nIf you have any problem about this App\nyou can send e-mail to zkh90644@gmail.com", preferredStyle: UIAlertControllerStyle.Alert)
        alertVC.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func pushToFavorite() {
        let vc = ZNFavoriteListTableViewController()
        self.leftBarVC.leftBarView.HideView()
        
        self.navVC.pushViewController(vc, animated: true)
    }
    
    func deleteCache() {
        let alertVC = UIAlertController.init(title: "警告", message: "您是否真的要清楚缓存", preferredStyle: UIAlertControllerStyle.Alert)
        alertVC.addAction(UIAlertAction.init(title: "是", style: UIAlertActionStyle.Default, handler: { (t) in
            let cacheTable = Table("cache")
            try! self.db!.run(cacheTable.delete())
            let DeleteCurrent = UIAlertController.init(title: "提醒", message: "缓存已经清除", preferredStyle: UIAlertControllerStyle.Alert)
            DeleteCurrent.addAction(UIAlertAction.init(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(DeleteCurrent, animated: true, completion: nil)
        }))
        
        alertVC.addAction(UIAlertAction.init(title: "否", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertVC, animated: true, completion: nil)
        
    }
    
//  MARK: corePageDelegate
    func numberOfPage() -> Int {
        return vcArray.count
    }
    
    func viewControllerOfIndex(index: Int) -> UIViewController {
        return vcArray[index]
    }
    
    func setFirstPageTag() -> Int {
        return 1
    }
    
    func setSelectLinePosition() -> Int {
        return coreTabPage.Position.Bottom.rawValue
    }
    
//  MARK:跳转界面代理
    func pushToNextViewController(title: String,url:String) {
        
        let nextVC = ZNNewInfoViewController(searchURL: url)
        nextVC.title = title
        self.navVC.pushViewController(nextVC, animated: true)
    }
    
//  MARK: 界面设计需要用到的函数
    func getButton(image:UIImage) -> UIButton {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setImage(image, forState: UIControlState.Normal)
        button.frame = CGRectMake(0, 0, 24, 24)
        
        return button
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func removeNavigationBarBlackLine() {
        let list = navVC.navigationBar.subviews
        for obj in list {
            if obj.isKindOfClass(UIImageView) {
                let blackView:UIImageView = obj as! UIImageView
                blackView.hidden = true
            }
        }
    }
}
