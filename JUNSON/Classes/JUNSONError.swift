//
//  JUNSONError.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/26.
//  Copyright © 2016年 Satoshi Nagasaka. All rights reserved.
//

import UIKit

public enum JUNSONError: Error {
    case serializationError
    case hasNoValue(String?)
    case hasNoValueForIndex(index: Int)
}

extension JUNSONError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .serializationError:
            return "serialization error"
        case .hasNoValue(let key):
            if let key = key {
                return "has no value for \"\(key)\" "
            }
            return "has no value"
        case .hasNoValueForIndex(let index):
            return "has no value at index \"\(index)\" "
        }
    }
}
