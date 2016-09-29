//
//  JUNSON.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/26.
//  Copyright © 2016年 Satoshi Nagasaka. All rights reserved.
//

import UIKit


public typealias JSONKeyPath = String

public typealias JSONIndexPath = Int

public protocol JUNSONType {
    
    var object: Any { get set }
    
    init(string: String, encoding: String.Encoding)
    
    init(data: Data, options: JSONSerialization.ReadingOptions)
    
    init(_ object: Any)
}

public extension JUNSONType {
    
    public init(string: String, encoding: String.Encoding = String.Encoding.utf8) {
        guard let data = string.data(using: encoding) else {
            self.init(NSNull())
            return
        }
        self.init(data:data)
    }
    
    public init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: options) else {
            self.init(NSNull())
            return
        }
        
        self.init(object)
    }
    
    public var asNormal: JSON {
        return JSON(object)
    }
    
    public var asOptional: OptionalJSON {
        return OptionalJSON(object)
    }
    
    public var asTry: TryJSON {
        return TryJSON(object)
    }
    
    public func export(key: JSONKeyPath) throws -> Self {
        if let dictionary = object as? [String:Any],let childObject = dictionary[key] {
            return Self(childObject)
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode<T: JUNSONDecodable>(key: JSONKeyPath) throws -> T {
        
        let value = try export(key: key).object
        if let value = T.decode(junson: Self(value)) {
            return value
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode(key: JSONKeyPath) throws -> [Self] {
        
        let value = try export(key: key).object
        if let value = value as? [Any] {
            return value.map({Self($0)})
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode(key: JSONKeyPath) throws -> [String:Self] {
        
        let value = try export(key: key).object
        if let dictionary = value as? [String:Any] {
            return dictionary.reduce([String:Self](), { (result, value) -> [String:Self] in
                var dict = result
                dict[value.key] = Self(value.value)
                return dict
            })
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode<T: JUNSONDecodable>(index: Int) throws -> T {
        
        guard let array = object as? [Any] , index > 0 && index < array.count else {
            throw JUNSONError.hasNoValueForIndex(index: index)
        }
        
        if let value = T.decode(junson: Self(array[index])) {
            return value
        }
        
        throw JUNSONError.hasNoValueForIndex(index: index)
    }
    
    internal func tryDecode(index: Int) throws -> [Self] {
        
        guard let array = object as? [Any] , index > 0 && index < array.count else {
            throw JUNSONError.hasNoValueForIndex(index: index)
        }
        
        if let value = array[index] as? [Any] {
            return value.map({Self($0)})
        }
        
        throw JUNSONError.hasNoValue(nil)
    }
    
    internal func tryDecode(index: Int) throws -> [String:Self] {
        
        guard let array = object as? [Any] , index > 0 && index < array.count else {
            throw JUNSONError.hasNoValueForIndex(index: index)
        }
        
        if let dictionary = array[index] as? [String:Any] {
            return dictionary.reduce([String:Self](), { (result, value) -> [String:Self] in
                var dict = result
                dict[value.key] = Self(value.value)
                return dict
            })
        }
        throw JUNSONError.hasNoValue(nil)
    }
    
    internal func tryDecode<T: JUNSONDecodable>() throws -> T {
        
        if let value = T.decode(junson: self) {
            return value
        }
        throw JUNSONError.hasNoValue(nil)
    }
    
    internal func tryDecode() throws -> [Self] {
        
        if let value = object as? [Any] {
            return value.map({Self($0)})
        }
        throw JUNSONError.hasNoValue(nil)
    }
    
    internal func tryDecode() throws -> [String:Self] {
        
        if let dictionary = object as? [String:Any] {
            return dictionary.reduce([String:Self](), { (result, value) -> [String:Self] in
                var dict = result
                dict[value.key] = Self(value.value)
                return dict
            })
        }
        throw JUNSONError.hasNoValue(nil)
    }
 
    internal func toArray() -> [Self]? {
        return (self.object as? [Any])?.map({Self($0)})
    }
}

public class JSON: JUNSONType {
    
    public var object: Any
    
    public var asArray: [JSON] {
        return toArray() ?? []
    }
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public subscript(key: String) -> JSON {
        if let json = try? export(key: key) {
            return json
        } else {
            return JSON(NSNull())
        }
    }
    
    public subscript(index: Int) -> JSON {
        if let array = self.object as? [Any] , index >= 0 && index < array.count {
            return JSON(array[index])
        } else {
            return JSON(NSNull())
        }
    }
    
    public func decode<T: JSONDecodeDefaultValuable>(key: JSONKeyPath) -> T {
        
        do {
            return try tryDecode(key: key)
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode(key: JSONKeyPath) -> [String:JSON] {
        
        do {
            let value: [String:JSON] = try tryDecode(key: key)
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode(key: JSONKeyPath) -> [JSON] {
        
        do {
            let value: [JSON] = try tryDecode(key: key)
            return value
        } catch {
            return []
        }
    }
    public func decode<T: JSONDecodeDefaultValuable>(index: Int) -> T {
        
        do {
            return try tryDecode(index: index)
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode(index: Int) -> [String:JSON] {
        
        do {
            let value: [String:JSON] = try tryDecode(index: index)
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode(index: Int) -> [JSON] {
        
        do {
            let value: [JSON] = try tryDecode(index: index)
            return value
        } catch {
            return []
        }
    }
    
    public func decode<T: JSONDecodeDefaultValuable>() -> T {
        
        do {
            return try tryDecode()
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode() -> [String:JSON] {
        
        do {
            let value: [String:JSON] = try tryDecode()
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode() -> [JSON] {
        
        do {
            let value: [JSON] = try tryDecode()
            return value
        } catch {
            return []
        }
    }
}

public class OptionalJSON: JUNSONType {
    
    public var object: Any
    
    public var asArray: [OptionalJSON]? {
        return toArray()
    }
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public subscript(key: String) -> OptionalJSON {
        if let json = try? export(key: key) {
            return json
        } else {
            return OptionalJSON(NSNull())
        }
    }
    
    public subscript(index: Int) -> OptionalJSON {
        if let array = self.object as? [Any] , index >= 0 && index < array.count {
            return OptionalJSON(array[index])
        } else {
            return OptionalJSON(NSNull())
        }
    }
    
    public func decode<T: JUNSONDecodable>(key: JSONKeyPath) -> T? {
        
        do {
            let value: T = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable,Z>(key: JSONKeyPath,transform: JUNSONTransformer<T,Z>) -> Z? {
        
        do {
            let value: T = try tryDecode(key: key)
            return try transform.exec(raw: value)
        } catch {
            return nil
        }
    }
    
    public func decode(key: JSONKeyPath) -> [OptionalJSON]? {
        
        do {
            let value: [OptionalJSON] = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode(key: JSONKeyPath) -> [String:OptionalJSON]? {
        
        do {
            let value: [String:OptionalJSON] = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable>(index: Int) -> T? {
        
        do {
            let value: T = try tryDecode(index: index)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable,Z>(index: Int,transform: JUNSONTransformer<T,Z>) -> Z? {
        
        do {
            let value: T = try tryDecode(index: index)
            return try transform.exec(raw: value)
        } catch {
            return nil
        }
    }
    
    public func decode(index: Int) -> [OptionalJSON]? {
        
        do {
            let value: [OptionalJSON] = try tryDecode(index: index)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode(index: Int) -> [String:OptionalJSON]? {
        
        do {
            let value: [String:OptionalJSON] = try tryDecode(index: index)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JSONDecodeDefaultValuable,Z>(trans: JUNSONTransformer<T,Z>) -> Z? {
        
        do {
            let rawValue: T = try tryDecode()
            return try trans.exec(raw: rawValue)
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable>() -> T? {
        
        do {
            let value: T = try tryDecode()
            return value
        } catch {
            return nil
        }
    }
    
    public func decode() -> [OptionalJSON]? {
        
        do {
            let value: [OptionalJSON] = try tryDecode()
            return value
        } catch {
            return nil
        }
    }
    
    public func decode() -> [String:OptionalJSON]? {
        
        do {
            let value: [String:OptionalJSON] = try tryDecode()
            return value
        } catch {
            return nil
        }
    }
    
}

public class TryJSON: JUNSONType {
    
    public var object: Any
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public func decode<T: JUNSONDecodable>(key: JSONKeyPath) throws -> T {
        
        return try tryDecode(key: key)
    }
    
    public func decode<T: JUNSONDecodable,Z>(key: JSONKeyPath,trans: JUNSONTransformer<T,Z>) throws -> Z {
        
        return try trans.exec(raw: tryDecode(key: key))
    }
    
    public func decode(key: JSONKeyPath) throws -> [TryJSON] {
        
        let value: [TryJSON] = try tryDecode(key: key)
        return value
    }
    
    public func decode(key: JSONKeyPath) throws -> [String:TryJSON]? {
        
        let value: [String:TryJSON] = try tryDecode(key: key)
        return value
    }
    
    public func decode<T: JUNSONDecodable>(index: Int) throws -> T {
        
        return try tryDecode(index: index)
    }
    
    public func decode<T: JUNSONDecodable,Z>(index: Int, trans: JUNSONTransformer<T,Z>) throws -> Z {
        
        return try trans.exec(raw: tryDecode(index: index))
    }
    
    public func decode(index: Int) throws -> [TryJSON] {
        
        let value: [TryJSON] = try tryDecode(index: index)
        return value
    }
    
    public func decode(index: Int) throws -> [String:TryJSON]? {
        
        let value: [String:TryJSON] = try tryDecode(index: index)
        return value
    }
    
    public func decode<T: JUNSONDecodable>() throws -> T {
        
        return try tryDecode()
    }
    
    public func decode<T: JUNSONDecodable,Z>(trans: JUNSONTransformer<T,Z>) throws -> Z {
        
        return try trans.exec(raw: tryDecode())
    }
    
    public func decode() throws -> [TryJSON] {
        
        let value: [TryJSON] = try tryDecode()
        return value
    }
    
    public func decode() throws -> [String:TryJSON]? {
        
        let value: [String:TryJSON] = try tryDecode()
        return value
    }
}
