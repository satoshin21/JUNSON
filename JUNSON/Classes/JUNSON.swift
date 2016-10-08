//
//  JUNSON.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/26.
//  Copyright © 2016年 Satoshi Nagasaka. All rights reserved.
//

import UIKit


public typealias JUNSONKeyPath = String

public typealias JUNSONIndexPath = Int

public protocol AnyJUNSON {
    
    var object: Any { get set }
    
    init(string: String, encoding: String.Encoding)
    
    init(data: Data, options: JSONSerialization.ReadingOptions)
    
    init(_ object: Any)
}

public extension AnyJUNSON {
    
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
    
    public var asDefault: JUNSON {
        return JUNSON(object)
    }
    
    public var asOptional: OptionalJUNSON {
        return OptionalJUNSON(object)
    }
    
    public var asTry: TryJUNSON {
        return TryJUNSON(object)
    }
    
    public func export(key: JUNSONKeyPath) throws -> Self {
        if let dictionary = object as? [String:Any],let childObject = dictionary[key] {
            return Self(childObject)
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode<T: JUNSONDecodable>(key: JUNSONKeyPath) throws -> T {
        
        let value = try export(key: key).object
        if let value = T.decode(junson: Self(value)) {
            return value
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode(key: JUNSONKeyPath) throws -> [Self] {
        
        let value = try export(key: key).object
        if let value = value as? [Any] {
            return value.map({Self($0)})
        }
        throw JUNSONError.hasNoValue(key)
    }
    
    internal func tryDecode(key: JUNSONKeyPath) throws -> [String:Self] {
        
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
    
    internal func tryDecode<T: JUNSONDecodable>(index: JUNSONIndexPath) throws -> T {
        
        guard let array = object as? [Any] , index > 0 && index < array.count else {
            throw JUNSONError.hasNoValueForIndex(index: index)
        }
        
        if let value = T.decode(junson: Self(array[index])) {
            return value
        }
        
        throw JUNSONError.hasNoValueForIndex(index: index)
    }
    
    internal func tryDecode(index: JUNSONIndexPath) throws -> [Self] {
        
        guard let array = object as? [Any] , index > 0 && index < array.count else {
            throw JUNSONError.hasNoValueForIndex(index: index)
        }
        
        if let value = array[index] as? [Any] {
            return value.map({Self($0)})
        }
        
        throw JUNSONError.hasNoValue(nil)
    }
    
    internal func tryDecode(index: JUNSONIndexPath) throws -> [String:Self] {
        
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
 
    internal func tryEncodeArray() throws -> [Self] {
        if let array = self.object as? [Any] {
            return array.map({Self($0)})
        }
        throw JUNSONError.notArrayObject
    }
    
    public subscript(key: String) -> Self {
        if let json = try? export(key: key) {
            return json
        } else {
            return Self(NSNull())
        }
    }
    
    public subscript(index: JUNSONIndexPath) -> Self {
        if let array = self.object as? [Any] , index >= 0 && index < array.count {
            return Self(array[index])
        } else {
            return Self(NSNull())
        }
    }
    
}

public extension AnyJUNSON {
    
    internal static func tryEncode(object: Any) throws -> Any {
        
        if let array = object as? [Any] {
            return try tryEncode(objects: array)
        } else if let dict = object as? [String:Any] {
            return try tryEncode(objects: dict)
        } else if let object = (object as? JUNSONEncodable)?.encode() {
            if let array = object as? [Any] {
                return try tryEncode(objects:array)
            } else if let dict = object as? [String:Any] {
                return try tryEncode(objects:dict)
            } else {
                throw JUNSONError.notDictionaryOrArray
            }
        }
        
        throw JUNSONError.noEncodableObject
    }
    
    internal static func tryEncode(objects: [String:Any?]) throws -> [String:Any] {
        
        var encoded = [String:Any]()
        
        for element in objects {
            
            let key = element.key
            
            if let array = element.value as? [Any] {
                encoded[key] = try tryEncode(objects: array)
            } else if let dict = element.value as? [String:Any] {
                encoded[key] = try tryEncode(objects: dict)
            } else if element.value == nil {
                encoded[key] = NSNull()
            } else if let encodable = element.value as? JUNSONEncodable {
                
                if let encodedElement = encodable.encode() {
                    
                    if let array = encodedElement as? [Any] {
                        encoded[key] = try tryEncode(object: array)
                    } else if let dict = encodedElement as? [String:Any] {
                        encoded[key] = try tryEncode(object: dict)
                    } else {
                        encoded[key] = encodedElement
                    }
                } else {
                    encoded[key] = NSNull()
                }
            } else {
                throw JUNSONError.noEncodableObject
            }
        }
        
        return encoded
    }
    
    internal static func tryEncode(objects: [Any?]) throws -> [Any] {
        
        var encoded = [Any]()
        
        for element in objects {
            
            if let array = element as? [Any] {
                encoded.append(try tryEncode(objects: array))
            } else if let dict = element as? [String:Any] {
                encoded.append(try tryEncode(objects: dict))
            } else if element == nil {
                encoded.append(NSNull())
            } else if let encodable = element as? JUNSONEncodable {
                
                if let encodedElement = encodable.encode() {
                    
                    if let array = encodedElement as? [Any] {
                        encoded.append(try tryEncode(object: array))
                    } else if let dict = encodedElement as? [String:Any] {
                        encoded.append(try tryEncode(object: dict))
                    } else {
                        encoded.append(encodedElement)
                    }
                } else {
                    encoded.append(NSNull())
                }
                
            } else {
                throw JUNSONError.noEncodableObject
            }
        }
        
        return encoded
    }
    
}

public class JUNSON: AnyJUNSON {
    
    public var object: Any
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public func toArray() -> [JUNSON] {
        do {
            return try tryEncodeArray()
        } catch {
            return []
        }
    }
    
    
    public func decode<T: JUNSONDecodable & JUNSONDefaultValue>(key: JUNSONKeyPath) -> T {
        
        do {
            return try tryDecode(key: key)
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode(key: JUNSONKeyPath) -> [String:JUNSON] {
        
        do {
            let value: [String:JUNSON] = try tryDecode(key: key)
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode(key: JUNSONKeyPath) -> [JUNSON] {
        
        do {
            let value: [JUNSON] = try tryDecode(key: key)
            return value
        } catch {
            return []
        }
    }
    
    public func decode<T: JUNSONDecodable & JUNSONDefaultValue>(index: JUNSONIndexPath) -> T {
        
        do {
            return try tryDecode(index: index)
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode(index: JUNSONIndexPath) -> [String:JUNSON] {
        
        do {
            let value: [String:JUNSON] = try tryDecode(index: index)
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode(index: JUNSONIndexPath) -> [JUNSON] {
        
        do {
            let value: [JUNSON] = try tryDecode(index: index)
            return value
        } catch {
            return []
        }
    }
    
    public func decode<T: JUNSONDecodable & JUNSONDefaultValue>() -> T {
        
        do {
            return try tryDecode()
        } catch {
            return T.defaultValue
        }
    }
    
    public func decode() -> [String:JUNSON] {
        
        do {
            let value: [String:JUNSON] = try tryDecode()
            return value
        } catch {
            return [:]
        }
    }
    
    public func decode() -> [JUNSON] {
        
        do {
            let value: [JUNSON] = try tryDecode()
            return value
        } catch {
            return []
        }
    }
    
    public static func encode(any: Any,writingOptions: JSONSerialization.WritingOptions = [.prettyPrinted]) -> Data {
        do  {
            
            let encoded: Any = try tryEncode(object: any)
            let data = try JSONSerialization.data(withJSONObject: encoded, options: writingOptions)
            return data
        } catch {
            return Data()
        }
    }
}

public class OptionalJUNSON: AnyJUNSON {
    
    public var object: Any
    
    public func toArray() -> [OptionalJUNSON]? {
        
        return try? tryEncodeArray()
    }
    
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public func decode<T: JUNSONDecodable>(key: JUNSONKeyPath) -> T? {
        
        do {
            let value: T = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable,Z>(key: JUNSONKeyPath,transform: JUNSONTransformer<T,Z>) -> Z? {
        
        do {
            let value: T = try tryDecode(key: key)
            return try transform.exec(raw: value)
        } catch {
            return nil
        }
    }
    
    public func decode(key: JUNSONKeyPath) -> [OptionalJUNSON]? {
        
        do {
            let value: [OptionalJUNSON] = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode(key: JUNSONKeyPath) -> [String:OptionalJUNSON]? {
        
        do {
            let value: [String:OptionalJUNSON] = try tryDecode(key: key)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable>(index: JUNSONIndexPath) -> T? {
        
        do {
            let value: T = try tryDecode(index: index)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable,Z>(index: JUNSONIndexPath,transform: JUNSONTransformer<T,Z>) -> Z? {
        
        do {
            let value: T = try tryDecode(index: index)
            return try transform.exec(raw: value)
        } catch {
            return nil
        }
    }
    
    public func decode(index: JUNSONIndexPath) -> [OptionalJUNSON]? {
        
        do {
            let value: [OptionalJUNSON] = try tryDecode(index: index)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode(index: JUNSONIndexPath) -> [String:OptionalJUNSON]? {
        
        do {
            let value: [String:OptionalJUNSON] = try tryDecode(index: index)
            return value
        } catch {
            return nil
        }
    }
    
    public func decode<T: JUNSONDecodable & JUNSONDefaultValue,Z>(trans: JUNSONTransformer<T,Z>) -> Z? {
        
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
    
    public func decode() -> [OptionalJUNSON]? {
        
        do {
            let value: [OptionalJUNSON] = try tryDecode()
            return value
        } catch {
            return nil
        }
    }
    
    public func decode() -> [String:OptionalJUNSON]? {
        
        do {
            let value: [String:OptionalJUNSON] = try tryDecode()
            return value
        } catch {
            return nil
        }
    }
    
    public static func encode(any: Any,writingOptions: JSONSerialization.WritingOptions = []) -> Data? {
        do  {
            
            let encoded: Any = try tryEncode(object: any)
            return try JSONSerialization.data(withJSONObject: encoded, options: writingOptions)
        } catch {
            return nil
        }
    }
}

public class TryJUNSON: AnyJUNSON {
    
    public var object: Any
    
    required public init(_ object: Any) {
        self.object = object
    }
    
    public func toArray() throws -> [TryJUNSON] {
        return try tryEncodeArray()
    }
    
    public func decode<T: JUNSONDecodable>(key: JUNSONKeyPath) throws -> T {
        
        return try tryDecode(key: key)
    }
    
    public func decode<T: JUNSONDecodable,Z>(key: JUNSONKeyPath,trans: JUNSONTransformer<T,Z>) throws -> Z {
        
        return try trans.exec(raw: tryDecode(key: key))
    }
    
    public func decode(key: JUNSONKeyPath) throws -> [TryJUNSON] {
        
        let value: [TryJUNSON] = try tryDecode(key: key)
        return value
    }
    
    public func decode(key: JUNSONKeyPath) throws -> [String:TryJUNSON]? {
        
        let value: [String:TryJUNSON] = try tryDecode(key: key)
        return value
    }
    
    public func decode<T: JUNSONDecodable>(index: JUNSONIndexPath) throws -> T {
        
        return try tryDecode(index: index)
    }
    
    public func decode<T: JUNSONDecodable,Z>(index: JUNSONIndexPath, trans: JUNSONTransformer<T,Z>) throws -> Z {
        
        return try trans.exec(raw: tryDecode(index: index))
    }
    
    public func decode(index: JUNSONIndexPath) throws -> [TryJUNSON] {
        
        let value: [TryJUNSON] = try tryDecode(index: index)
        return value
    }
    
    public func decode(index: JUNSONIndexPath) throws -> [String:TryJUNSON] {
        
        let value: [String:TryJUNSON] = try tryDecode(index: index)
        return value
    }
    
    public func decode<T: JUNSONDecodable>() throws -> T {
        
        return try tryDecode()
    }
    
    public func decode<T: JUNSONDecodable,Z>(trans: JUNSONTransformer<T,Z>) throws -> Z {
        
        return try trans.exec(raw: tryDecode())
    }
    
    public func decode() throws -> [TryJUNSON] {
        
        let value: [TryJUNSON] = try tryDecode()
        return value
    }
    
    public func decode() throws -> [String:TryJUNSON] {
        
        let value: [String:TryJUNSON] = try tryDecode()
        return value
    }
    
    public static func encode(any: Any,writingOptions: JSONSerialization.WritingOptions = []) throws -> Data {
        let jsonObject = try tryEncode(object: any)
        return try JSONSerialization.data(withJSONObject: jsonObject, options: writingOptions)
    }
}
