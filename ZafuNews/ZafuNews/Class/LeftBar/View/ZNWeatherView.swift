//
//  ZNWeatherView.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/10/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import CoreLocation

class ZNWeatherView: UIView {
    
    let backgroundImage = UIImage.init(named: "WeatherBackground")
    var currentTem = UILabel()
    var date = UILabel()
    var position = UILabel()
    var temInterval = UILabel()
    var weatherInterval = UILabel()
    var tempSymbol = UILabel()
    var weatherImageView = UIImageView()
    var refresh = UIButton.init(type: UIButtonType.Custom)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initView()
    }
    
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        //设置背景
        self.backgroundColor = UIColor.init(patternImage: backgroundImage!)
        
        setUpData()
        
        setUpView()

    }
    
    func getDate() -> NSString {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let DateString = dateFormatter.stringFromDate(NSDate())
        
        return DateString
    }
    
    func setUpData() {
        //      设置文字
        currentTem.text = "nil"
        date.text = self.getDate() as String
        position.text = "nil"
        temInterval.text = "nil"
        weatherInterval.text = "AQI:000"
        tempSymbol.text = "℃"
        weatherImageView.image = UIImage.init(named: "sunny")
        let tempImage = UIImageView.init(image: UIImage.init(named: "refresh"))
        refresh.addSubview(tempImage)
        tempImage.snp_makeConstraints { (make) in
            make.edges.equalTo(refresh)
        }
        
        currentTem.font = UIFont.init(name: "Bangla Sangam MN", size: 70)
        date.font = UIFont.init(name: "Arial Rounded MT Bold", size: 20)
        position.font = UIFont.init(name: "Arial Rounded MT Bold", size: 16)
        temInterval.font = UIFont.init(name: "Arial Rounded MT Bold", size: 20)
        weatherInterval.font = UIFont.init(name: "Bangla Sangam MN", size: 16)
        tempSymbol.font = UIFont.init(name: "Arial Rounded MT Bold", size: 40)
        
        currentTem.textColor = UIColor.whiteColor()
        date.textColor = UIColor.whiteColor()
        position.textColor = UIColor.whiteColor()
        temInterval.textColor = UIColor.whiteColor()
        weatherInterval.textColor = UIColor.whiteColor()
        tempSymbol.textColor = UIColor.whiteColor()
        
        position.textAlignment = NSTextAlignment.Right
        
    }
    
    func setUpView() {
        self.addSubview(currentTem)
        self.addSubview(date)
        self.addSubview(position)
        self.addSubview(temInterval)
        self.addSubview(weatherInterval)
        self.addSubview(weatherImageView)
        self.addSubview(refresh)
        self.addSubview(tempSymbol)
        
        currentTem.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self).offset(10)
        }
        date.snp_makeConstraints { (make) in
            make.left.equalTo(currentTem)
            make.top.equalTo(currentTem.snp_bottom).offset(10)
        }
        position.snp_makeConstraints { (make) in
            make.centerY.equalTo(date)
            make.right.equalTo(self).offset(-15)
        }
        temInterval.snp_makeConstraints { (make) in
            make.left.equalTo(currentTem.snp_right)
            make.bottom.equalTo(currentTem).offset(-10)
        }
        weatherInterval.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(position)
        }
        tempSymbol.snp_makeConstraints { (make) in
            make.centerY.equalTo(currentTem.snp_top).offset(20)
            make.left.equalTo(currentTem.snp_right)
        }
        refresh.snp_makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(15)
            make.top.equalTo(self).offset(25)
            make.right.equalTo(self).offset(-10)
        }
        weatherImageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.right.equalTo(position)
            make.bottom.equalTo(weatherInterval.snp_top).offset(-8)
        }
        
        
        
        
    }
}
