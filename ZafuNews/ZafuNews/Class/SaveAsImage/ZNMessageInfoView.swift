//
//  ZNMessageInfoView.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/31/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNMessageInfoView: UIView {

    var viewArray = Array<UIView>()
    var image:UIImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(viewArr:Array<UIView>){
        self.init(frame:CGRectZero)
        
        self.viewArray = viewArr
    }
    
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
//        1.获取上下文
        let context = UIGraphicsGetCurrentContext()
        
//        2.变换坐标
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextTranslateCTM(context, 0, self.bounds.size.height)
        CGContextScaleCTM(context, 1, -1)
        
//        3.绘制区域设置
        let path = UIBezierPath(rect: rect)
        
        for view in self.viewArray {
            if view.isKindOfClass(UILabel) {
                let label = view as! UILabel
                let mutableAttrString = NSMutableAttributedString(string: label.text!)
                mutableAttrString.addAttributes([NSFontAttributeName:20], range: NSMakeRange(0, mutableAttrString.length))
                let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrString)
                let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrString.length), path.CGPath, nil)
                
                CTFrameDraw(frame, context!)
            }
        }
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()        
    }
 

}
