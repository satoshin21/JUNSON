//
//  Person.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import JUNSON

struct Person: JSONDecodeDefaultValuable,JSONEncodable {
    
    let name: String
    let height: String
    let mass: String
    
    static func decode(json: JUNSON) -> Person? {
        let normal = json.asNormal
        
        let dateTransform = JSONTransform<String,Date>({ (string) -> Date? in
            return Date()
        })
        
        let created = normal["created"].asOptional.decode(trans: dateTransform)
        return Person(name: normal.decode(key: "name"),
                      height: normal.decode(key: "height"),
                      mass: normal.decode(key: "mass"))
    }
    
    static var defaultValue: Person {
        return Person(name: "", height: "", mass: "")
    }
    
    func encode() -> Any? {
        return ["name":name,"height":height,"mass":mass]
    }
    
    let transform = JSONTransform<String,Date> { string -> Date in
        return Date()
    }
}
