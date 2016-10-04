//
//  DecodableTests.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/10/05.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import XCTest
import JUNSON

class DecodableEncodableTests: XCTestCase {
    
    let jsonStr = "[{\"id\":0,\"name\":\"John\"},{\"id\":1,\"name\":\"Doe\"},{\"id\":2,\"name\":null}]"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDecodableEncodableObject() {
        
        let json = JUNSON(string:jsonStr)
        let objects: [TestObject] = json.toArray().map({$0.decode()})
        XCTAssertEqual(3, objects.count)
        
        XCTAssertEqual(objects[0].id, 0)
        XCTAssertEqual(objects[0].name, "John")
        XCTAssertEqual(objects[1].id, 1)
        XCTAssertEqual(objects[1].name, "Doe")
        XCTAssertEqual(objects[2].id, 2)
        XCTAssertEqual(objects[2].name, nil)
        
        let data = JUNSON.encode(any: objects)
        
        guard let string = String(data: data, encoding: .utf8) else {
            XCTFail()
            return
        }
        
        XCTAssertNotEqual(string, "")
    }
}

struct TestObject: JUNSONDecodable,JUNSONDefaultValue,JUNSONEncodable {
    
    let id: Int
    let name: String?
    
    static func decode(junson: AnyJUNSON) -> TestObject? {
        return TestObject(id: junson.asNormal.decode(key: "id"),
                          name: junson.asOptional.decode(key: "name"))
    }
    
    func encode() -> Any? {
        
        var dict = [String:Any]()
        dict["id"] = id
        dict["name"] = name
        return dict
    }
    
    static var defaultValue: TestObject {
        return TestObject(id: 0, name: nil)
    }
}
