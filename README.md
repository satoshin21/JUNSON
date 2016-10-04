# JUNSON

[![Version](https://img.shields.io/cocoapods/v/JUNSON.svg?style=flat)](http://cocoapods.org/pods/JUNSON)
[![License](https://img.shields.io/cocoapods/l/JUNSON.svg?style=flat)](http://cocoapods.org/pods/JUNSON)
[![Platform](https://img.shields.io/cocoapods/p/JUNSON.svg?style=flat)](http://cocoapods.org/pods/JUNSON)

**JUNSON** is JSON decode and encode Library for Swift3.0.

```swift
// decode json to person object.

let json = JUNSON(data: data)
let lukeSkywalker: Person = json["results"][0].decode()

// by Optional
let darthVader: Person = json["results"][1].asOptional.decode()

// by try-Catch
do {
	let leiaOrgana: Person = json["results"][2].asTry.decode()
} catch {
}
```

## Features

JUNSON is simple library for encoding/decoding JSON for Swift.

* **type-safe** JSON decode.
* make any type decodable by implementing *JUNSONDecodable*
* make any type encodable by implementing *JUNSONEncodable*
* handling decode/encode error by **try-catch**, **optional**, and **replacing with default value**(like SwiftyJSON).

## Example

### Create JUNSON object with any objects
First of all, you have to create **JUNSON** object to access json easily.
You can create JUNSON object with various type (like String,NSData,AnyObject).


**String**

```swift
// with String	
let rawValue: String = "{\"hoge\":\"hoge\",\"foo\":1,\"bar\":0.12 }"
let junson = JUNSON(string: rawValue)
```

**Data**

```swift
let rawData: Data = rawValue.data(using: .utf8)!
let junson = JUNSON(data: rawValue)
```

### Retrieve the value[WIP]
when you retrieve value from JSON, you do not need specify value type.

```swift
class Person {
	let name: String = ""
	let age: Int = 0
}
let junson = JUNSON(string:string)
let person = Person()

person.name = junson.decode(key:"name")
person.name = junson["age"].decode()
```

Implementing *JUNSONDecodable* to your class, or struct,  
decoding JSON is more easily.

```swift
class Person: JUNSONDecodable {
	let name: String = ""
	let age: Int = 0
	
	// AnyJUNSON is protocol implemented by JUNSON,OptionalJUNSON and TryJUNSON
   static func decode(junson: AnyJUNSON) -> Person? {
    	let defaultJunson = junson.asDefault
    	return Person(name: defaultJunson.decode(key: "name"),
    					 age: defaultJunson.decode(key: "age"))
   }
	
}

let junson = JUNSON(string:string)
let person = junson.decode()
```

To retrieve the value,
JUNSON supports various approaches to handle parsing error.

#### handling by default value (like SwiftyJSON)
when decode error occured, If you want to replace object by specified value(default value), use **JUNSON**
*when you use JUNSON,please implement **JUNSONDefaultValue** to your class/struct,and define default value.

```swift
class Person: JUNSONDecodable,JUNSONDefaultValue {
	
    static var defaultValue: Person {
    	return Person(name:"",age:20)
    }
	
	static func decode(junson: AnyJUNSON) -> Person? {
   ..
   }
	
}

let junson = JUNSON(string:string)
let person: Person = junson.asDefault.decode()
```

#### handling by Optional
* there is potential that object is not exist, use **OptionalJUNSON(or JUNSON.asOptional)**

```swift

let junson = OptionalJUNSON(string:string) // or JUNSON(string;string).asOptional

let person: Person? = junson.asDefault
```

#### try-catch
* If you want to decode JSON more strictly, use **TryJUNSON(or JUNSON.asTry)**

```swift

let junson = TryJUNSON(string:string) // or JUNSON(string;string).asTry
do {
	let person: Person = try json.decode()
} catch JUNSONError.hasNoValue(let key) {
	// failed decoding value
}
```

### Encode
By implementing **JUNSONEncodable** to your any class/structs, you can encode object to JSON more easily.

```swift
class Person: JUNSONEncodable {
	let name: String
	let age: Int
	
    func encode() -> Any? {
    	return ["name",name,"age",age]
    }
}

var persons = [Person]()
persons.append(Person(name:"Luke Skywalker",age:19))
persons.append(Person(name:"Darth Vader",age:42))
persons.append(Person(name:"Leia Organa",age:19))

let dict = [String:Any]()
dict["count"] = persons.count
dict["persons"] = persons

let data = JUNSON.encode(any:dict)
let string: String = String(data:data,encoding: .utf8)!
/*
{
    "count": 3, 
    "persons": [
        {
            "age": 19, 
            "name": "Luke Skywalker"
        }, 
        {
            "age": 42, 
            "name": "Darth Vader"
        }, 
        {
            "age": 19, 
            "name": "Leia Organa"
        }
    ]
}
*/
```


## Requirements

Swift **3.0** , Xcode8

## Installation

JUNSON is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JUNSON"
```

## Author

SatoshiN21, satoshi.nagasaka21@gmail.com

## License

JUNSON is available under the MIT license. See the LICENSE file for more info.
