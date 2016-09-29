//
//  Transformable.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//
//

open class JUNSONTransformer<T:JUNSONDecodable,Z> {
    
    private let transformer: (T) throws -> Z
    
    public init(_ transformer: @escaping (T) throws -> Z) {
        self.transformer = transformer
    }
    
    internal func exec(raw: T) throws -> Z {
        let value = try transformer(raw)
        return value
    }
}
