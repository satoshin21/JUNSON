//
//  JUNSON.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/26.
//  Copyright © 2016年 Satoshi Nagasaka. All rights reserved.
//

import UIKit


public typealias KeyPath = String

public typealias IndexPath = Int

public protocol JUNSON {
    
    var object: Any { get set }
    
    init(string: String, encoding: String.Encoding)
    
    init(data: Data, options: JSONSerialization.ReadingOptions)
    
    init(_ object: Any)
}

extension JUNSON {
    
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
    
    var asNormal: JSON {
        return JSON(object)
    }
    
    var asOptional: OptionalJSON {
        return OptionalJSON(object)
    }
    
    var asTry: TryJSON {
        return TryJSON(object)
    }
    
    public func export(key: KeyPath) throws -> Self {
        if let dictionary = object as? [String:Any],let childObject = dictionary[key] {
            return Self(childObject)
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode<T: JSONDecodable>(key: KeyPath) throws -> T {
        
        let value = try export(key: key).object
        if let value = T.decode(json: Self(value)) {
            return value
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode(key: KeyPath) throws -> [Self] {
        
        let value = try export(key: key).object
        if let value = value as? [Any] {
            return value.map({Self($0)})
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode(key: KeyPath) throws -> [String:Self] {
        
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
    
    internal func tryDecode<T: JSONDecodable>(index: Int) throws -> T {
        
        guard let array = object as? [Any] , index > 0 && index < array.count else {
            throw JUNSONError.hasNoValueForIndex(index: index)
        }
        
        if let value = T.decode(json: Self(array[index])) {
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
    
    internal func tryDecode<T: JSONDecodable>() throws -> T {
        
        if let value = T.decode(json: self) {
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
    
}

public class JSON: JUNSON {
    
    public var object: Any
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public func decode<T: JSONDecodeDefaultValuable>(key: KeyPath) -> T {
        
        do {
            return try tryDecode(key: key)
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode(key: KeyPath) -> [String:JSON] {
        
        do {
            let value: [String:JSON] = try tryDecode(key: key)
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode(key: KeyPath) -> [JSON] {
        
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

public class OptionalJSON: JUNSON {
    
    public var object: Any
    
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
        if let array = self.object as? [Any] , index > 0 && index < array.count {
            return OptionalJSON(array[index])
        } else {
            return OptionalJSON(NSNull())
        }
    }
    
    public func decode<T: JSONDecodable>(key: KeyPath) -> T? {
        
        do {
            let value: T = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode(key: KeyPath) -> [OptionalJSON]? {
        
        do {
            let value: [OptionalJSON] = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode(key: KeyPath) -> [String:OptionalJSON]? {
        
        do {
            let value: [String:OptionalJSON] = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JSONDecodable>(index: Int) -> T? {
        
        do {
            let value: T = try tryDecode(index: index)
            return value
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
    
    public func decode<T: JSONDecodable>() -> T? {
        
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

public class TryJSON: JUNSON {
    
    public var object: Any
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public func decode<T: JSONDecodable>(key: KeyPath) throws -> T {
        
        return try tryDecode(key: key)
    }
    
    public func decode(key: KeyPath) throws -> [TryJSON] {
        
        let value: [TryJSON] = try tryDecode(key: key)
        return value
    }
    
    public func decode(key: KeyPath) throws -> [String:TryJSON]? {
        
        let value: [String:TryJSON] = try tryDecode(key: key)
        return value
    }
    
    public func decode<T: JSONDecodable>(index: Int) throws -> T {
        
        return try tryDecode(index: index)
    }
    
    public func decode(index: Int) throws -> [TryJSON] {
        
        let value: [TryJSON] = try tryDecode(index: index)
        return value
    }
    
    public func decode(index: Int) throws -> [String:TryJSON]? {
        
        let value: [String:TryJSON] = try tryDecode(index: index)
        return value
    }
    
    
    public func decode<T: JSONDecodable>() throws -> T {
        
        return try tryDecode()
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
