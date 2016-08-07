//
//  ZNLeftBarViewController.swift
//  ZafuNews
//
//  Created by zkhCreator on 8/6/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ZNLeftBarViewController: UIViewController,CLLocationManagerDelegate {
    
    var leftBarView = ZNLeftBarView()
    var finishedRefresh = false
    let locationManager = CLLocationManager.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(nibName:nil,bundle:nil)
        locationManager.delegate = self;
        leftBarView.leftView.weatherView.refresh.addTarget(self, action: #selector(updateWeather), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func updateWeather() {
        
        //        refresh按钮开始旋转
        self.finishedRefresh = true
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
}
