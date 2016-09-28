# JunSON

[![CI Status](http://img.shields.io/travis/SatoshiN21/JunSON.svg?style=flat)](https://travis-ci.org/SatoshiN21/JunSON)
[![Version](https://img.shields.io/cocoapods/v/JunSON.svg?style=flat)](http://cocoapods.org/pods/JunSON)
[![License](https://img.shields.io/cocoapods/l/JunSON.svg?style=flat)](http://cocoapods.org/pods/JunSON)
[![Platform](https://img.shields.io/cocoapods/p/JunSON.svg?style=flat)](http://cocoapods.org/pods/JunSON)

**JunSON** is JSON decode and encode Library for Swift.

## Features

JunSON is simple library for encode/decode JSON for Swift.

* type-safe JSON decode
* handling decode error by try, optional, and replacing with default value. 

## Example

### Create JunSON object with any objects
First of all, you have to create **JunSON** object to access json easily.  
You can create JunSON object with various type (like String,NSData,AnyObject).

**String**

```swift
// with String	
let rawValue: String = "{\"hoge\":\"hoge\",\"foo\":1,\"bar\":0.12 }"
let junson = try JunSON(string: rawValue)
```

**NSData**

```swift
let rawData: NSData = rawValue.data(using: .utf8)!
let junson = try JunSON(data: rawValue)
```

**AnyObject (like response object by Alamofire)**

```swift
Alamofire.request("https://foo.bar").responseJSON { response in
	let junson = try JunSON(object:response.result.value!)
}
```

### Retrieve the value
To retrieve the value,
JunSON supports various approaches to handle parsing error.

**try catch**

```swift
do {
	let jsonString = "{\"hoge\":\"hoge\",\"foo\":1,\"bar\":0.12 }"
	let json = try JunSON(string:jsonString)
    
    let string: String = try "noValueKey" <=?? json
} catch let e {
    print(e)	// has no value for "noValueKey"
}
```

**Optional**

```swift
let json = try! JunSON(string:jsonString)
let string: String? = "noValueKey" <=? json
print(string) // nil 
```

**Replace with Default Value (like SwiftyJSON)**

```swift
let json = try! JunSON(string:jsonString)
let string: String? = "noValueKey" <=? json
print(string) // nil 
```



## Requirements

## Installation

JunSON is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JunSON"
```

## Author

SatoshiN21, satoshi.nagasaka@eure.jp

## License

JunSON is available under the MIT license. See the LICENSE file for more info.
