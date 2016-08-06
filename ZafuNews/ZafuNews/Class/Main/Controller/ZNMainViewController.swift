//
//  ZNMainViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/9/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import Alamofire
import SwiftyJSON

let defaultColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1)
let key = "71bbf3830b814ff19f1698ae02b2dfe0"

let webURLArray = ["http://news.zafu.edu.cn/articles/3/",
                   "http://news.zafu.edu.cn/articles/75/",
                   "http://news.zafu.edu.cn/articles/39/",
                   "http://news.zafu.edu.cn/articles/53/",
                   "http://news.zafu.edu.cn/articles/10/",
                   "http://news.zafu.edu.cn/articles/54/",
                   "http://news.zafu.edu.cn/articles/7/",
                   "http://news.zafu.edu.cn/articles/59/",
                   "http://news.zafu.edu.cn/articles/79/"]

class ZNMainViewController: UIViewController,coreTabViewDelegate,pushToInfoNewDelegate,CLLocationManagerDelegate{

    let navVC = ZNNavigationController.init()
    var switchView = coreTabPage()
    let leftBarView = ZNLeftBarView()
    let mainVC = UIViewController()
    let locationManager = CLLocationManager.init()
    var finishedRefresh = false
    
    lazy var vcArray:Array<UIViewController> = Array<UIViewController>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchView.delegate = self;
        locationManager.delegate = self;

        initTitleView()
        initLeftBarView()
        
        self.leftBarView.leftView.weatherView.refresh.addTarget(self, action: #selector(updateWeather), forControlEvents: UIControlEvents.TouchUpInside)
        for item in self.leftBarView.leftView.buttonArr {
            let button = item as! ZNLeftListCell
            if button.cellName == "关于我们" {
                button.addTarget(self, action: #selector(aboutMe), forControlEvents: UIControlEvents.TouchUpInside)
            }
            if button.cellName == "我的收藏" {
                button.addTarget(self, action: #selector(pushToFavorite), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func initLeftBarView() {
        view.addSubview(leftBarView)
        
        leftBarView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    func initMainVC() {
        
        for i in 0..<webURLArray.count {
            let vc = ZNInfoListViewController(url:webURLArray[i])
            self.vcArray.append(vc)
            switch i {
            case 0:
                vc.title = "学校要闻"
                break;
            case 1:
                vc.title = "综合新闻"
                break;
            case 2:
                vc.title = "部门传真"
                break;
            case 3:
                vc.title = "学院快讯"
                break;
            case 4:
                vc.title = "创新创业"
                break;
            case 5:
                vc.title = "学术动态"
                break;
            case 6:
                vc.title = "师生风采"
                break;
            case 7:
                vc.title = "媒体关注"
                break;
            case 8:
                vc.title = "菁菁校园"
                break;
            default:
                print("error")
            }
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
        leftBarView.showView()
    }
    
    func pushToQRScan() {
        let qrscanVC = ZNQRScanViewController()
        self.navVC.pushViewController(qrscanVC, animated: true)
    }
    
    func pressSearchButton() {
        let vc = ZNSearchViewController()
        self.navVC.pushViewController(vc, animated: false)
    }
    
    func getWeather(city:String) {
        let url = "https://api.heweather.com/x3/weather?city="+city+"&key="+key
        Alamofire.request(.GET, url.urlEncode()!).responseJSON { (response) in
            switch response.result{
            case .Success:
                let json = JSON(data: response.data!)
                let info = json["HeWeather data service 3.0"][0]
                
                let city = info["basic"]["city"]
                let aqi = info["aqi"]["city"]["aqi"]
                let tmp = info["now"]["tmp"]
                let sky = info["now"]["cond"]["code"]
                let max = info["daily_forecast"][0]["tmp"]["max"]
                let min = info["daily_forecast"][0]["tmp"]["min"]
                let date = info["daily_forecast"][0]["date"]
                
                let weatherURL = "http://files.heweather.com/cond_icon/"+sky.string!+".png"
                
                Alamofire.request(.GET, weatherURL).responseImage(completionHandler: { (response) in
                    let image = UIImage.init(data: response.data!)?.imageReplaceColor(UIColor.whiteColor())
                    let mainQueue = dispatch_get_main_queue()
                    dispatch_async(mainQueue, {
                        
                        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
                        path?.appendContentsOf("/weather.plist")
                        
                        let manager = NSFileManager.defaultManager()
                        
                        if !(manager.fileExistsAtPath(path!)){
                            if manager.createFileAtPath(path!, contents: nil, attributes: nil) == true {
                                print("create success")
                            }else{
                                print("create false")
                            }
                            
                        }

                        let dic = NSMutableDictionary.init(capacity: 6)
                        dic.setValue(tmp.string, forKey: "tmp")
                        dic.setValue(city.string, forKey: "position")
                        dic.setValue(aqi.string, forKey: "AQI")
                        dic.setValue(min.string! + "℃/"+max.string!+"℃", forKey: "minToMax")
                        dic.setValue(date.string, forKey: "date")
                        dic.setValue(UIImagePNGRepresentation(image!), forKey: "weather")
                        
                        print(dic)
                        
                        if (dic.writeToFile(path!, atomically: true) == true){
                            print("true")
                        }else{
                            print(false)
                        }
//                        dic?.writeToFile(path!, atomically: true)
                        
                        let view = self.leftBarView.leftView.weatherView
                        
                        UIView.animateWithDuration(0.5, animations: {
                            view.date.alpha = 0
                            view.currentTem.alpha = 0
                            view.position.alpha = 0
                            view.weatherImageView.alpha = 0
                            view.weatherInterval.alpha = 0
                            view.temInterval.alpha = 0
                            view.tempSymbol.alpha = 0
                            }, completion: { (finished) in
                                if (finished) {
                                    view.refresh.layer.removeAnimationForKey("rotate-layer")
                                    view.date.text = date.string
                                    view.currentTem.text = tmp.string
                                    view.position.text = city.string
                                    view.weatherInterval.text = "AQI:"+aqi.string!
                                    view.temInterval.text = min.string! + "℃/"+max.string!+"℃"
                                    view.weatherImageView.image = image
                                    
                                    UIView.animateWithDuration(0.5, animations: {
                                        view.date.alpha = 1
                                        view.currentTem.alpha = 1
                                        view.position.alpha = 1
                                        view.weatherImageView.alpha = 1
                                        view.weatherInterval.alpha = 1
                                        view.temInterval.alpha = 1
                                        view.tempSymbol.alpha = 1
                                    })
                                }
                        })
                    })
                })
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func aboutMe() {
        let alertVC = UIAlertController.init(title: "About Me", message: "This App code by zkhCreator\nIf you have any problem about this App\nyou can send e-mail to zkh90644@gmail.com", preferredStyle: UIAlertControllerStyle.Alert)
        alertVC.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func pushToFavorite() {
        let vc = ZNFavoriteListTableViewController()
        self.leftBarView.HideView()
        
        self.navVC.pushViewController(vc, animated: true)
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
    
    func updateWeather() {
//        refresh按钮开始旋转
        self.finishedRefresh = true
//        self.leftBarView.leftView.weatherView.refresh.rotateView(value: &self.finishedRefresh)
        let animated = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animated.repeatCount = HUGE
        animated.duration = 1
        animated.fromValue = NSNumber.init(int: 0)
        animated.toValue = NSNumber.init(double: 2 * M_PI)
        self.leftBarView.leftView.weatherView.refresh.layer.addAnimation(animated, forKey: "rotate-layer")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
//  MARK:跳转界面代理
    func pushToNextViewController(title: String,url:String) {
        let nextVC = ZNNewInfoViewController(searchURL: url)
        nextVC.title = title
        self.navVC.pushViewController(nextVC, animated: true)
    }

//  MARK:获得GPS的代理
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(locations[0]) { (array, error) in
            if error == nil {
                if array!.count > 0{
                    let placemark = array![0] as CLPlacemark
                    //                print(placemark)
                    var city = placemark.subLocality;
                    if city == nil{
                        city = placemark.locality
                        if (city == nil) {
                            //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                            city = placemark.administrativeArea;
                        }
                    }else{
                        let strArr = city?.componentsSeparatedByString("\'")
                        
                        if strArr?.count > 1{
                            city = ""
                            for string in strArr! {
                                city?.appendContentsOf(string)
                            }
                        }
                    }
//                    发送请求获取天气json
                    self.getWeather(city!)
                }
            }
        }
        manager.stopUpdatingLocation()
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
