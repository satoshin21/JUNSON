//
//  JUNSONEncodable.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//  Copyright © 2016年 Satoshi Nagasaka. All rights reserved.
//

import Foundation

public protocol JUNSONEncodable {
    func encode() -> Any?
}


extension String: JUNSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Double: JUNSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Float: JUNSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Int: JUNSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}
