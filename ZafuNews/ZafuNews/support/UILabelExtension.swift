//
//  UILabelExtension.swift
//  ZafuNews
//
//  Created by zkhCreator on 8/3/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

extension UILabel{
    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.drawInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}