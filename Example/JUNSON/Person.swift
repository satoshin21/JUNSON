//
//  Person.swift
//  JUNSON
//
//  Created by Satoshi Nagasaka on 2016/09/29.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import JUNSON

enum Gender: String {
    case male = "male"
    case female = "female"
    case none = "none"
}

struct Person: JUNSONDecodable,JUNSONDefaultValue,JUNSONEncodable {
    
    let name: String
    let height: Double
    let gender: Gender?
    let films: [Film]
    
    static func decode(junson json: AnyJUNSON) -> Person? {
        let normal = json.asNormal
        
        return Person(name: normal["name"].decode(),
                      height: normal["height"].decode(),
                      gender: normal.asOptional["gender"].decode(trans: genderTransformer),
                      films: normal["films"].asArray.map({$0.decode()}))
    }
    
    static var defaultValue: Person {
        return Person(name: "", height: 0, gender: nil, films: [])
    }
    
    func encode() -> Any? {
        return ["name":name,"height":height,"gender":gender?.rawValue,"films":films]
    }
    
    static let genderTransformer = JUNSONTransformer<String,Gender> { string -> Gender in
        switch string {
        case "male":
            return .male
        case "female":
            return .female
        default:
            return .none
        }
    }
}

struct Film: JUNSONDecodable,JUNSONDefaultValue,JUNSONEncodable {
    
    let episode: UInt
    let title: String
    let releaseDate: Date?
    
    static func decode(junson: AnyJUNSON) -> Film? {
        let normal = junson.asNormal
        let film =  Film(episode: normal["episode"].decode(),
                    title: normal["title"].decode(),
                    releaseDate: normal.asOptional.decode(key: "release_date", transform: ReleaseDateTransformer()))
        return film
    }
    
    func encode() -> Any? {
        return ["episode":episode,"title":title]
    }
    
    static var defaultValue: Film {
        return Film(episode: 0, title: "", releaseDate: nil)
    }
}

class ReleaseDateTransformer: JUNSONTransformer<String,Date> {
    
    init() {
        super.init({(string) throws -> Date in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: string) {
                return date
            } else {
                throw DateFormatError.failedTransform
            }
        })
    }
}

enum DateFormatError: Error {
    case failedTransform
}
