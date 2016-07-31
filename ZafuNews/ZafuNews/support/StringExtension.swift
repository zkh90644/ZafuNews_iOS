//
//  StringExtension.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/30/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import Foundation

extension String {
    func urlEncode() -> String? {
        let unreserved = "!=:-._~/&?"
        let allowed = NSMutableCharacterSet.alphanumericCharacterSet()
        allowed.addCharactersInString(unreserved)
        return stringByAddingPercentEncodingWithAllowedCharacters(allowed)
    }
    
    
}
