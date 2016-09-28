//
//  Exportable.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2016/09/14.
//
//

public protocol JSONDecodeDefaultValuable: JSONDecodable {
    static var defaultValue: Self { get }
}

public protocol JSONDecodable {
    
    static func decode(json: JUNSON) -> Self?
}

extension String: JSONDecodeDefaultValuable {
    
    public static func decode(json: JUNSON) -> String? {
        return json.object as? String
    }
    
    public static var defaultValue: String {
        return ""
    }
}

extension Double: JSONDecodeDefaultValuable {
    
    public static func decode(json: JUNSON) -> Double? {
        return json.object as? Double
    }
    
    public static var defaultValue: Double {
        return 0.0
    }
}

extension Float: JSONDecodeDefaultValuable {
    
    public static func decode(json: JUNSON) -> Float? {
        return json.object as? Float
    }
    
    public static var defaultValue: Float {
        return 0.0
    }
}

extension Int: JSONDecodeDefaultValuable {
    
    public static func decode(json: JUNSON) -> Int? {
        return json.object as? Int
    }
    
    public static var defaultValue: Int {
        return 0
    }
}
