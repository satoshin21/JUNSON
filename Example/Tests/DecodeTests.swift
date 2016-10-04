import UIKit
import XCTest
import JUNSON

class DecodeTests: XCTestCase {
    
    let data = Data(referencing: NSData(contentsOfFile: Bundle(for: DecodeTests.self).path(forResource: "decode_test", ofType: "json")!)!)
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func testDecodeDefault() {
        
        let json = JUNSON(data:data)
        XCTAssertEqual("string", json.decode(key: "string"))
        XCTAssertEqual("string", json["string"].decode())
        XCTAssertEqual(3.141592, json.decode(key: "double"))
        XCTAssertEqual(3.141592, json["double"].decode())
        XCTAssertEqual(3.141592, json.decode(key: "float"))
        XCTAssertEqual(3.141592, json["float"].decode())
        XCTAssertEqual(205253, json.decode(key: "int"))
        XCTAssertEqual(205253, json["int"].decode())
        XCTAssertEqual(Int8.min, json.decode(key: "int8"))
        XCTAssertEqual(Int8.min, json["int8"].decode())
        XCTAssertEqual(Int16.min, json.decode(key: "int16"))
        XCTAssertEqual(Int16.min, json["int16"].decode())
        XCTAssertEqual(Int32.min, json.decode(key: "int32"))
        XCTAssertEqual(Int32.min, json["int32"].decode())
        XCTAssertEqual(Int64.min, json.decode(key: "int64"))
        XCTAssertEqual(Int64.min, json["int64"].decode())
        XCTAssertEqual(UInt8.max, json.decode(key: "uint8"))
        XCTAssertEqual(UInt8.max, json["uint8"].decode())
        XCTAssertEqual(UInt16.max, json.decode(key: "uint16"))
        XCTAssertEqual(UInt16.max, json["uint16"].decode())
        XCTAssertEqual(UInt32.max, json.decode(key: "uint32"))
        XCTAssertEqual(UInt32.max, json["uint32"].decode())
        XCTAssertEqual(UInt64.max, json.decode(key: "uint64"))
        XCTAssertEqual(UInt64.max, json["uint64"].decode())
        
        let array: [String] = json["array"].toArray().map({$0.decode()})
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], "value1")
        XCTAssertEqual(array[1], "value2")
        XCTAssertEqual(array[2], "value3")
        
        let treeJson = json["tree1"]["tree2"]
        XCTAssertEqual("dict-string", treeJson.decode(key: "string"))
        XCTAssertEqual("dict-string", treeJson["string"].decode())
        XCTAssertEqual(205253, treeJson.decode(key: "int"))
        XCTAssertEqual(205253, treeJson["int"].decode())
        
        // default value test
        
        XCTAssertEqual("", json.decode(key: "null"))
        XCTAssertEqual(Int(0), json.decode(key: "null"))
        XCTAssertEqual(Int8(0), json.decode(key: "null"))
        XCTAssertEqual(Int16(0), json.decode(key: "null"))
        XCTAssertEqual(Int32(0), json.decode(key: "null"))
        XCTAssertEqual(Int64(0), json.decode(key: "null"))
        XCTAssertEqual(UInt(0), json.decode(key: "null"))
        XCTAssertEqual(UInt8(0), json.decode(key: "null"))
        XCTAssertEqual(UInt16(0), json.decode(key: "null"))
        XCTAssertEqual(UInt32(0), json.decode(key: "null"))
        XCTAssertEqual(UInt64(0), json.decode(key: "null"))
    }
    
    func testDecodeOptional() {
        
        let json = JUNSON(data:data).asOptional
        XCTAssertEqual("string", json.decode(key: "string"))
        XCTAssertEqual("string", json["string"].decode())
        XCTAssertEqual(3.141592, json.decode(key: "double"))
        XCTAssertEqual(3.141592, json["double"].decode())
        XCTAssertEqual(3.141592, json.decode(key: "float"))
        XCTAssertEqual(3.141592, json["float"].decode())
        XCTAssertEqual(205253, json.decode(key: "int"))
        XCTAssertEqual(205253, json["int"].decode())
        XCTAssertEqual(Int8.min, json.decode(key: "int8"))
        XCTAssertEqual(Int8.min, json["int8"].decode())
        XCTAssertEqual(Int16.min, json.decode(key: "int16"))
        XCTAssertEqual(Int16.min, json["int16"].decode())
        XCTAssertEqual(Int32.min, json.decode(key: "int32"))
        XCTAssertEqual(Int32.min, json["int32"].decode())
        XCTAssertEqual(Int64.min, json.decode(key: "int64"))
        XCTAssertEqual(Int64.min, json["int64"].decode())
        XCTAssertEqual(UInt8.max, json.decode(key: "uint8"))
        XCTAssertEqual(UInt8.max, json["uint8"].decode())
        XCTAssertEqual(UInt16.max, json.decode(key: "uint16"))
        XCTAssertEqual(UInt16.max, json["uint16"].decode())
        XCTAssertEqual(UInt32.max, json.decode(key: "uint32"))
        XCTAssertEqual(UInt32.max, json["uint32"].decode())
        XCTAssertEqual(UInt64.max, json.decode(key: "uint64"))
        XCTAssertEqual(UInt64.max, json["uint64"].decode())
        
        let array: [OptionalJUNSON]? = json["array"].toArray()
        XCTAssertEqual(array?.count, 3)
        XCTAssertEqual(array?[0].decode(), "value1")
        XCTAssertEqual(array?[1].decode(), "value2")
        XCTAssertEqual(array?[2].decode(), "value3")
        
        let treeJson = json["tree1"]["tree2"]
        XCTAssertEqual("dict-string", treeJson.decode(key: "string"))
        XCTAssertEqual("dict-string", treeJson["string"].decode())
        XCTAssertEqual(205253, treeJson.decode(key: "int"))
        XCTAssertEqual(205253, treeJson["int"].decode())
        
        // nil value test
        let nullString: String? = json.decode(key: "null")
        XCTAssertEqual(nil, nullString)
    }
    
    
    func testDecodeTryCatch() {
        
        let json = JUNSON(data:data).asTry
        do {
            XCTAssertEqual("string", try json.decode(key: "string"))
            XCTAssertEqual("string", try json["string"].decode())
            XCTAssertEqual(3.141592, try json.decode(key: "double"))
            XCTAssertEqual(3.141592, try json["double"].decode())
            XCTAssertEqual(3.141592, try json.decode(key: "float"))
            XCTAssertEqual(3.141592, try json["float"].decode())
            XCTAssertEqual(205253, try json.decode(key: "int"))
            XCTAssertEqual(205253, try json["int"].decode())
            XCTAssertEqual(Int8.min, try json.decode(key: "int8"))
            XCTAssertEqual(Int8.min, try json["int8"].decode())
            XCTAssertEqual(Int16.min, try json.decode(key: "int16"))
            XCTAssertEqual(Int16.min, try json["int16"].decode())
            XCTAssertEqual(Int32.min, try json.decode(key: "int32"))
            XCTAssertEqual(Int32.min, try json["int32"].decode())
            XCTAssertEqual(Int64.min, try json.decode(key: "int64"))
            XCTAssertEqual(Int64.min, try json["int64"].decode())
            XCTAssertEqual(UInt8.max, try json.decode(key: "uint8"))
            XCTAssertEqual(UInt8.max, try json["uint8"].decode())
            XCTAssertEqual(UInt16.max, try json.decode(key: "uint16"))
            XCTAssertEqual(UInt16.max, try json["uint16"].decode())
            XCTAssertEqual(UInt32.max, try json.decode(key: "uint32"))
            XCTAssertEqual(UInt32.max, try json["uint32"].decode())
            XCTAssertEqual(UInt64.max, try json.decode(key: "uint64"))
            XCTAssertEqual(UInt64.max, try json["uint64"].decode())
            
            let array: [String] = try json["array"].toArray().map({try $0.decode()})
            XCTAssertEqual(array.count, 3)
            XCTAssertEqual(array[0], "value1")
            XCTAssertEqual(array[1], "value2")
            XCTAssertEqual(array[2], "value3")
            
            let treeJson = json["tree1"]["tree2"]
            XCTAssertEqual("dict-string", try treeJson.decode(key: "string"))
            XCTAssertEqual("dict-string", try treeJson["string"].decode())
            XCTAssertEqual(205253, try treeJson.decode(key: "int"))
            XCTAssertEqual(205253, try treeJson["int"].decode())
        } catch {
            XCTFail()
        }
        
        // nil value test
        do {
            let _: String = try json.decode(key: "null")
            XCTFail()
        } catch JUNSONError.hasNoValue(let key) {
            XCTAssertEqual(key, "null")
        } catch {
            XCTFail()
        }
    }
}
