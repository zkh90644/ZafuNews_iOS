//
//  coreTabPage.swift
//  coreTabPage
//
//  Created by zkhCreator on 6/14/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class coreTabPage: UIView,UIScrollViewDelegate {
    
    enum Position:Int {
        case Top = 0,Middle,Bottom
    }
    
    var delegate:coreTabViewDelegate?
    
//    界面样式
    var tabMargin:CGFloat = 10
    let tabHight:CGFloat = 40
    var titleSize:CGFloat = 14
    var maxButtonWidth:CGFloat = 0
    var tabBackground:UIColor = UIColor.whiteColor()
    var baseLine:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.whiteColor()
        line.setWidth(0)
        line.setHeight(2)
        return line
    }()
    
//    基本属性
    lazy var viewControllersArray:Array<UIViewController> = Array<UIViewController>()
    lazy var tabsArray:Array<UIButton> = Array<UIButton>()
    lazy var redDotsArray:Array<UIView> = Array<UIView>()
    lazy var currentPageTag:Int = 0
    lazy var startTag:Int = 0
    lazy var selectedLineOffsetXBeforeMoving:CGFloat = 0
    lazy var speed:CGFloat = 50
    
//    两个scrollView
    lazy var bodyScrollView:UIScrollView = {
        let bodyScrollView = UIScrollView.init()
        bodyScrollView.pagingEnabled = true
        bodyScrollView.userInteractionEnabled = true
        bodyScrollView.bounces = false
        bodyScrollView.showsHorizontalScrollIndicator = false
        bodyScrollView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .FlexibleHeight,.FlexibleBottomMargin,.FlexibleWidth)
        return bodyScrollView
    }()
    lazy var tabScrollView:UIScrollView = {
        let tabScrollView = UIScrollView.init()
        tabScrollView.userInteractionEnabled = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .FlexibleHeight,.FlexibleBottomMargin,.FlexibleWidth)
        return tabScrollView
    }()
    
//    用来判断状态的值
    var isBuild:Bool = false
    var isUsingDragging:Bool = false    //用来防止在点击tab的时候调用scrollView
    var continueDraggingNumber:Int = 0
    var startOffset:CGFloat = 0
    var customLine:Bool = false
    
    func BuildIn() {
        isBuild = true
        let count = self.delegate?.numberOfPage()
        self.addSubview(bodyScrollView)
        self.addSubview(tabScrollView)
        tabScrollView.addSubview(baseLine)
        if ((self.delegate?.setSelectLineStye?()) != nil) {
            customLine = true
            
//          直接通过basLine = changView的话后面值会消失，不知道原因
            
            let changeView = (self.delegate?.setSelectLineStye!())!
            
            baseLine.setHeight(changeView.height)
            baseLine.backgroundColor = changeView.backgroundColor
            baseLine.layer.masksToBounds = changeView.layer.masksToBounds
            baseLine.layer.cornerRadius = changeView.layer.cornerRadius
        }
        
        bodyScrollView.frame = CGRectMake(0, tabHight, self.width, self.height)
        tabScrollView.frame = CGRectMake(self.left, self.top , self.width, tabHight)
        
        bodyScrollView.delegate = self;
        
        for i in 0..<count! {
//            将vc放入scrollView和array
            let vc = self.delegate?.viewControllerOfIndex(i)
            viewControllersArray.append(vc!)
            bodyScrollView.addSubview(vc!.view)
            
//            将tabButton放入array
            let tabItem = UIButton(type: UIButtonType.Custom)
            tabItem.setTitle(vc?.title, forState: UIControlState.Normal)
            tabItem.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
            tabItem.titleLabel?.font = UIFont.systemFontOfSize(titleSize)
            tabItem.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.6), forState: UIControlState.Normal)
            tabItem.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            tabItem.addTarget(self, action:#selector(coreTabPage.selectTabButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            tabItem.tag = i
            tabScrollView.addSubview(tabItem)
            tabsArray.append(tabItem)
            
//            将红点加入tabButton
            let redDot = UIView()
            redDot.backgroundColor = UIColor.redColor()
            redDot.layer.masksToBounds = true
            redDot.hidden = true
            redDot.tag = i
            redDotsArray.append(redDot)
            tabItem.addSubview(redDot)
        }
        
        tabScrollView.backgroundColor = tabBackground
        isBuild = true
        
        self.setNeedsLayout()
        
    }
    
    private func buttonTitleRealSize(button:UIButton) -> CGSize {
        let string =  (button.titleLabel?.text)! as NSString
        return string.sizeWithAttributes([NSFontAttributeName:(button.titleLabel?.font)!])
    }
    
    override func layoutSubviews() {
        if isBuild {
//          仅在设置完成后，设置界面的位置，设置两个scrollView，防止占用过多资源
            bodyScrollView.contentSize = CGSize.init(width: self.width * CGFloat(viewControllersArray.count) , height: self.tabHight)
            
            var buttonSumWidth:CGFloat = 0
//          获得按钮的总长度
//          为了防止某些按钮太宽导致样式变丑
            for i in 0..<tabsArray.count {
                let button = tabsArray[i]
                if maxButtonWidth < buttonTitleRealSize(button).width {
                    maxButtonWidth = buttonTitleRealSize(button).width + 10
                }
            }
            
//          获得按钮总长度
            buttonSumWidth = maxButtonWidth * CGFloat( tabsArray.count )
            
//          获取tab总长度，如果小于self的宽度，那么均分，否则用scrollView滚动，margin变小
            if self.width > buttonSumWidth {
                maxButtonWidth = ( self.width - tabMargin * 2 ) / CGFloat( tabsArray.count )
            }else{
                speed = 10
            }

            var sumTabWidth:CGFloat = tabMargin
            for i in 0..<viewControllersArray.count {
//                内容的scrollView
                let vc:UIViewController = viewControllersArray[i]
                vc.view.frame = CGRect.init(x: bodyScrollView.width * CGFloat(i), y: 0, width: bodyScrollView.width, height: bodyScrollView.height)
                
//                tab的scrollView
                let btn:UIButton = tabsArray[i]
                btn.frame = CGRectMake(sumTabWidth, 0, maxButtonWidth, tabHight)
                if ((self.delegate?.setTabColorNormal?()) != nil) {
                    btn.setTitleColor(self.delegate?.setTabColorNormal!(), forState: UIControlState.Normal)
                }
                
                if ((self.delegate?.setTabColorSelected?()) != nil) {
                    btn.setTitleColor(self.delegate?.setTabColorSelected!(), forState: UIControlState.Selected)
                }
                
                
//                小红点的frame
                let redDot = redDotsArray[i]
                redDot.frame = CGRect.init(x: (maxButtonWidth / 2) + (buttonTitleRealSize(btn).width / 2), y: (btn.height / 2) - buttonTitleRealSize(btn).height / 2 - 3, width: 8, height: 8)
                redDot.layer.cornerRadius = redDot.width / 2
                
                
                sumTabWidth += maxButtonWidth
            }
            sumTabWidth += tabMargin
            tabScrollView.contentSize = CGSize.init(width: sumTabWidth,height: tabHight)
            
//            设置起始页
            
            if ((self.delegate?.setFirstPageTag?()) == nil) {
                startTag = 0
            }else if self.delegate?.setFirstPageTag?() > tabsArray.count {
                startTag = 0
            }else
            {
                startTag = (self.delegate?.setFirstPageTag?())!
                bodyScrollView.setContentOffset(CGPoint.init(x:self.width * CGFloat( startTag ), y: 0), animated: false)
            }
            self.baseLine.setWidth(self.buttonTitleRealSize(self.tabsArray[startTag]).width)
            self.baseLine.setCenterX(self.tabsArray[startTag].centerX)
            
//            self.baseLine.setTop(self.tabScrollView.height - 2)
            
            if self.delegate?.setSelectLinePosition?() != nil {
                if let position = Position.init(rawValue: (self.delegate?.setSelectLinePosition?())!){
                    switch position {
                    case .Top:
                        baseLine.setTop(0)
                    case .Middle:
                        self.baseLine.setCenterY(self.tabScrollView.centerY)
                    case .Bottom:
                        fallthrough
                    default:
                        self.baseLine.setTop(self.tabScrollView.height - 2)
                    }
                }
            }
            selectPage(startTag, isAnimate: false)
        }
    }
    
    private func selectPage(index:Int,isAnimate:Bool) {
//        tab的跳转
        let preButton = tabsArray[currentPageTag]
        preButton.selected = false
        currentPageTag = index
        let currentButton = tabsArray[index]
        currentButton.selected = true
        
        var buttonWidth:CGFloat = 0
        if customLine {
            buttonWidth = self.buttonTitleRealSize(self.tabsArray[index]).width + 5
        }else{
            buttonWidth = self.buttonTitleRealSize(self.tabsArray[index]).width
        }
        
        if isAnimate {
            UIView.animateWithDuration(0.25, animations: {
//              设置下划线的位置
                self.baseLine.setWidth(buttonWidth)
                self.baseLine.setCenterX(self.tabsArray[index].centerX)
                self.selectedLineOffsetXBeforeMoving = self.baseLine.origin.x
            })
        }else{
            self.baseLine.setWidth(buttonWidth)
            self.baseLine.setCenterX(self.tabsArray[index].centerX)
            self.selectedLineOffsetXBeforeMoving = self.baseLine.origin.x
        }
        
        tabScrollView.scrollRectToVisible(currentButton.frame, animated: true)
        
//        内容scrollView的跳转
        switchContent(index,isAnimate: isAnimate)

        hideRedDot(index)
    }
    
    private func selectPage(index:Int) {
        self.selectPage(index, isAnimate: false)
    }
    
    private func switchContent(index:Int,isAnimate:Bool) {
        bodyScrollView.setContentOffset(CGPointMake(CGFloat(index) * self.width, 0), animated: true)
        isUsingDragging = false
    }
    
    func selectTabButton(sender:UIButton) {
        selectPage(sender.tag,isAnimate: true)
    }
    
//    滚动条移动的动画
    func moveSelectedLineByScrollWithOffsetX(offsetX:CGFloat) {
        let textGap:CGFloat = (self.width - self.tabMargin * 2 - self.baseLine.width * CGFloat( tabsArray.count )) / ( CGFloat( self.tabsArray.count ) * 2)
        
        let moveLength:CGFloat = selectedLineOffsetXBeforeMoving + ( offsetX * (textGap + baseLine.width + speed)) / UIScreen.mainScreen().bounds.width //用来防止超过左右最大距离
        let maxRightMove:CGFloat = selectedLineOffsetXBeforeMoving + textGap * 2 + baseLine.width
        let maxLeftMove:CGFloat = selectedLineOffsetXBeforeMoving - textGap * 2 - baseLine.width
        var lineMoveActually:CGFloat = 0
        
        var isContinueDragging:Bool = false
        //多手指移动判断
        if continueDraggingNumber > 1 {
            isContinueDragging = true
        }
        
        if moveLength > maxRightMove && !isContinueDragging {
            lineMoveActually = maxRightMove
        }else if moveLength < maxLeftMove && !isContinueDragging {
            lineMoveActually = maxLeftMove
        }else{
//            如果存在多指移动，导致移动过长需要阻止
            if isContinueDragging {
                if moveLength > bodyScrollView.contentSize.width - (tabMargin + textGap + baseLine.width){
                    lineMoveActually = bodyScrollView.contentSize.width - (tabMargin + textGap + baseLine.width)
                }else if moveLength < self.tabMargin + textGap{
                    lineMoveActually = self.tabMargin + textGap
                }else{
                    lineMoveActually = moveLength
                }
            }else{
                lineMoveActually = moveLength
            }
        }
        
        baseLine.frame = CGRect.init(origin: CGPoint.init(x: lineMoveActually, y: baseLine.frame.origin.y), size: baseLine.frame.size)
    }
    
    func showRedDot(index:Int) {
        redDotsArray[index].hidden = false
    }
    
    func hideRedDot(index:Int) {
        redDotsArray[index].hidden = true
    }
    
    // MARK:scrollView Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.isEqual(bodyScrollView) {
            continueDraggingNumber += 1
            
            startOffset = bodyScrollView.contentOffset.x
            isUsingDragging = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isEqual(bodyScrollView) {
            let offsetX = scrollView.contentOffset.x - startOffset
            if isUsingDragging {
                moveSelectedLineByScrollWithOffsetX(offsetX)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.isEqual(self.bodyScrollView) {
            let index:Int = Int( scrollView.contentOffset.x / self.bounds.size.width )
            selectPage(index, isAnimate: true)
            isUsingDragging = true
        }
    }
}

@objc protocol coreTabViewDelegate {
    
    optional func setSelectLinePosition() -> Int
    optional func setFirstPageTag() -> Int
    optional func setSelectLineStye() -> UIView
    optional func setTabColorNormal() -> UIColor
    optional func setTabColorSelected() -> UIColor
    
    func viewControllerOfIndex(index:Int) -> UIViewController
    func numberOfPage() -> Int
    
}
