//
//  Person.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import JUNSON

struct Person: JUNSONDecodable,JUNSONDefaultValue,JUNSONEncodable {
    
    let name: String
    let height: String
    let mass: String
    let createdDate: Date?
    let films: [String]
    
    static func decode(junson json: AnyJUNSON) -> Person? {
        let normal = json.asNormal
        
        let dateTransform = JUNSONTransformer<String,Date>({ (string) throws -> Date in
            return Date()
        })
        
        
        
        return Person(name: normal.decode(key: "name"),
                      height: normal.decode(key: "height"),
                      mass: normal.decode(key: "mass"),
                      createdDate: normal.asOptional.decode(key: "created", transform: dateTransform),
                      films: normal["films"].asArray.map({$0.decode()})
                    )
    }
    
    static var defaultValue: Person {
        return Person(name: "", height: "", mass: "",createdDate: nil,films: [])
    }
    
    func encode() -> Any? {
        return ["name":name,"height":height,"mass":mass]
    }
    
    let transform = JUNSONTransformer<String,Date> { string -> Date in
        return Date()
    }
}

class DateTransformer: JUNSONTransformer<String,Date> {
    
    init() {
        super.init({(string) throws -> Date in
            return Date()
        })
    }
}
