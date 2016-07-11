//
//  ZNMainViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/9/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import SnapKit

let defaultColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1)

class ZNMainViewController: UIViewController,coreTabViewDelegate{

    let navVC = ZNNavigationController.init()
    var switchView = coreTabPage()
    let leftBarView = ZNLeftBarView()
    let mainVC = UIViewController()
    lazy var vcArray:Array<UIViewController> = Array<UIViewController>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchView.delegate = self;
        
        initTitleView()
        initLeftBarView()
        
//        代理
    }
    
//    MARK:界面设计
    
    func initTitleView() {
        //设置navigationBar size
        let oldFrame = view.frame
        let newFrame = CGRectMake(0, 20, oldFrame.width, oldFrame.height)
        navVC.view.frame = newFrame
        
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
    
    func initLeftBarView() {
        view.addSubview(leftBarView)
        
        leftBarView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    func initMainVC() {
        let vc1 = ZNInfoListViewController()
        vc1.title = "联系我们"
        vc1.view.backgroundColor = self.randomColor()
        let vc2 = ZNInfoListViewController()
        vc2.title = "故障解答"
        vc2.view.backgroundColor = self.randomColor()
        let vc3 = ZNInfoListViewController()
        vc3.title = "经验交流"
        vc3.view.backgroundColor = self.randomColor()
        let vc4 = ZNInfoListViewController()
        vc4.title = "近期公告"
        vc4.view.backgroundColor = self.randomColor()
        let vc5 = ZNInfoListViewController()
        vc5.title = "IT资讯"
        vc5.view.backgroundColor = self.randomColor()
        let vc6 = ZNInfoListViewController()
        vc6.title = "网上报修"
        vc6.view.backgroundColor = self.randomColor()
        
        self.vcArray.append(vc1)
        self.vcArray.append(vc2)
        self.vcArray.append(vc3)
        self.vcArray.append(vc4)
        self.vcArray.append(vc5)
        self.vcArray.append(vc6)
        
        mainVC.view.addSubview(switchView)
        let frame = UIScreen.mainScreen().bounds
        switchView.frame = CGRectMake(0, 0, frame.width, frame.height)
        switchView.tabBackground = defaultColor
        
        
        switchView.BuildIn()
        
    }
    
    func setTitleButton() {
        //        设置左侧按钮
        let leftButton = getButton(UIImage.init(named: "list")!)
        leftButton.addTarget(self, action: #selector(leftViewAction), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem.init(customView: leftButton)
        navVC.navigationBar.topItem?.leftBarButtonItem = leftItem
        
        //        设置右边按钮
        let scanButton = getButton(UIImage.init(named: "scan")!)
        scanButton.addTarget(self, action: #selector(printWorld), forControlEvents: UIControlEvents.TouchUpInside)
        let scanBarButton = UIBarButtonItem.init(customView: scanButton)
        
        let searchButton = getButton(UIImage.init(named: "search")!)
        searchButton.addTarget(self, action: #selector(printWorld), forControlEvents: UIControlEvents.TouchUpInside)
        let searchBarButton = UIBarButtonItem.init(customView: searchButton)
        
        navVC.navigationBar.topItem?.rightBarButtonItems = [searchBarButton,scanBarButton]

    }
    
//  MARK: 按钮的action
    func leftViewAction() {
        leftBarView.showView()
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
    
////  MARK: TableView delegate
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
//        if cell == nil {
//            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
//            cell?.textLabel?.text = "helloworld"
//        }
//        
//        return cell!
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
//    
//    
    
//  MARK: 界面设计需要用到的函数
    func getButton(image:UIImage) -> UIButton {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setImage(image, forState: UIControlState.Normal)
        button.frame = CGRectMake(0, 0, 24, 24)
        
        return button
    }
    
    func printWorld() {
        print("hellworld")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 255) / 255.0
        let g = CGFloat(arc4random() % 255) / 255.0
        let b = CGFloat(arc4random() % 255) / 255.0
        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
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
