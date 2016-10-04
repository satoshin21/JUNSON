//
//  EncodeTest.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/10/05.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import XCTest
import JUNSON

class EncodeTest: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testEncode() {
        
        // encode
        var dict = [String:Any]()
        dict["string"] = "string"
        dict["double"] = 3.141592
        dict["float"] = 3.141592
        dict["int"] = 205253
        dict["int8"] = Int8.min
        dict["int16"] = Int16.min
        dict["int32"] = Int32.min
        dict["int64"] = Int64.min
        dict["uint8"] = UInt8.max
        dict["uint16"] = UInt16.max
        dict["uint32"] = UInt32.max
        dict["uint64"] = UInt64.max
        dict["array"] = ["value1","value2","value3"]
        
        let data = JUNSON.encode(any: dict)
        let json = OptionalJUNSON(data:data)
        
        // decode
        
        XCTAssertEqual("string",  json["string"].decode())
        XCTAssertEqual(3.141592,  json["double"].decode())
        XCTAssertEqual(3.141592,  json["float"].decode())
        XCTAssertEqual(205253,  json["int"].decode())
        XCTAssertEqual(Int8.min,  json["int8"].decode())
        XCTAssertEqual(Int16.min,  json["int16"].decode())
        XCTAssertEqual(Int32.min,  json["int32"].decode())
        XCTAssertEqual(Int64.min,  json["int64"].decode())
        XCTAssertEqual(UInt8.max,  json["uint8"].decode())
        XCTAssertEqual(UInt16.max, json["uint16"].decode())
        XCTAssertEqual(UInt32.max, json["uint32"].decode())
        XCTAssertEqual(UInt64.max, json["uint64"].decode())
    }
}
