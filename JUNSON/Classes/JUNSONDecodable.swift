//
//  Exportable.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2016/09/14.
//
//

import UIKit

public protocol JUNSONDefaultValue {
    static var defaultValue: Self { get }
}

public protocol JUNSONDecodable {
    
    static func decode(junson: AnyJUNSON) -> Self?
}

extension String: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> String? {
        return junson.object as? String
    }
    
    public static var defaultValue: String {
        return ""
    }
}

extension Double: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Double? {
        return junson.object as? Double
    }
    
    public static var defaultValue: Double {
        return 0.0
    }
}

extension Float: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Float? {
        return junson.object as? Float
    }
    
    public static var defaultValue: Float {
        return 0.0
    }
}

extension Int: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Int? {
        return junson.object as? Int
    }
    
    public static var defaultValue: Int {
        return 0
    }
}

extension Int8: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Int8? {
        if let number = junson.object as? NSNumber {
            return number.int8Value
        }
        return nil
    }
    
    public static var defaultValue: Int8 {
        return 0
    }
}

extension Int16: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Int16? {
        if let number = junson.object as? NSNumber {
            return number.int16Value
        }
        return nil
    }
    
    public static var defaultValue: Int16 {
        return 0
    }
}

extension Int32: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Int32? {
        if let number = junson.object as? NSNumber {
            return number.int32Value
        }
        return nil
    }
    
    public static var defaultValue: Int32 {
        return 0
    }
}

extension Int64: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> Int64? {
        if let number = junson.object as? NSNumber {
            return number.int64Value
        }
        return nil
    }
    
    public static var defaultValue: Int64 {
        return 0
    }
}

extension UInt: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> UInt? {
        return junson.object as? UInt
    }
    
    public static var defaultValue: UInt {
        return 0
    }
}

extension UInt8: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> UInt8? {
        if let number = junson.object as? NSNumber {
            return number.uint8Value
        }
        return nil
    }
    
    public static var defaultValue: UInt8 {
        return 0
    }
}

extension UInt16: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> UInt16? {
        if let number = junson.object as? NSNumber {
            return number.uint16Value
        }
        return nil
    }
    
    public static var defaultValue: UInt16 {
        return 0
    }
}

extension UInt32: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> UInt32? {
        if let number = junson.object as? NSNumber {
            return number.uint32Value
        }
        return nil
    }
    
    public static var defaultValue: UInt32 {
        return 0
    }
}

extension UInt64: JUNSONDecodable, JUNSONDefaultValue {
    
    public static func decode(junson: AnyJUNSON) -> UInt64? {
        if let number = junson.object as? NSNumber {
            return number.uint64Value
        }
        return nil
    }
    
    public static var defaultValue: UInt64 {
        return 0
    }
}
