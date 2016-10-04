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

extension NSNumber: JUNSONEncodable {
    
    public func encode() -> Any? {
        return self
    }
}

extension Double: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension Float: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension Int: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension Int8: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension Int16: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension Int32: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension Int64: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension UInt: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension UInt8: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension UInt16: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension UInt32: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension UInt64: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNumber(value:self)
    }
}

extension NSNull: JUNSONEncodable {
    
    public func encode() -> Any? {
        return NSNull()
    }
}
