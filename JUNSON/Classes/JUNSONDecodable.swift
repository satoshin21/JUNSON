//
//  Exportable.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2016/09/14.
//
//

public protocol JSONDecodeDefaultValuable: JUNSONDecodable {
    static var defaultValue: Self { get }
}

public protocol JUNSONDecodable {
    
    static func decode(junson: JUNSONType) -> Self?
}

extension String: JSONDecodeDefaultValuable {
    
    public static func decode(junson: JUNSONType) -> String? {
        return junson.object as? String
    }
    
    public static var defaultValue: String {
        return ""
    }
}

extension Double: JSONDecodeDefaultValuable {
    
    public static func decode(junson: JUNSONType) -> Double? {
        return junson.object as? Double
    }
    
    public static var defaultValue: Double {
        return 0.0
    }
}

extension Float: JSONDecodeDefaultValuable {
    
    public static func decode(junson: JUNSONType) -> Float? {
        return junson.object as? Float
    }
    
    public static var defaultValue: Float {
        return 0.0
    }
}

extension Int: JSONDecodeDefaultValuable {
    
    public static func decode(junson: JUNSONType) -> Int? {
        return junson.object as? Int
    }
    
    public static var defaultValue: Int {
        return 0
    }
}