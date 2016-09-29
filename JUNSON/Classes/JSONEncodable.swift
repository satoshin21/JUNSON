//
//  JSONEncodable.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//  Copyright © 2016年 Satoshi Nagasaka. All rights reserved.
//

import Foundation

public protocol JSONEncodable {
    func encode() -> Any?
}


extension String: JSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Double: JSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Float: JSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Int: JSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}
