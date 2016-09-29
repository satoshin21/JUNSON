//
//  Transformable.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//
//

public struct JSONTransform<T:JSONDecodable,Z> {
    
    private let transformer: (T) -> Z?
    
    public init(_ transformer: @escaping (T) -> Z?) {
        self.transformer = transformer
    }
    
    internal func exec(raw: T) -> Z? {
        let value = transformer(raw)
    return value
    }
}
