# JUNSON

[![CI Status](http://img.shields.io/travis/SatoshiN21/JUNSON.svg?style=flat)](https://travis-ci.org/SatoshiN21/JUNSON)
[![Version](https://img.shields.io/cocoapods/v/JUNSON.svg?style=flat)](http://cocoapods.org/pods/JUNSON)
[![License](https://img.shields.io/cocoapods/l/JUNSON.svg?style=flat)](http://cocoapods.org/pods/JUNSON)
[![Platform](https://img.shields.io/cocoapods/p/JUNSON.svg?style=flat)](http://cocoapods.org/pods/JUNSONJUNSON)

**JUNSON** is JSON decode and encode Library for Swift.

```swift
let lukeSkywalker: Person = JSON(data: data)["results"][0].decode()
```

## Features

JUNSON is simple library for encoding/decoding JSON for Swift.

* type-safe JSON decode
* handling decode error by try, optional, and replacing with default value. 

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

**NSData**

```swift
let rawData: NSData = rawValue.data(using: .utf8)!
let junson = JUNSON(data: rawValue)
```

**AnyObject (like response object by Alamofire)**

```swift
Alamofire.request("https://foo.bar").responseJSON { response in
	let junson = JUN(object:response.result.value!)
}
```

### Retrieve the value[WIP]
To retrieve the value,
JUNSON supports various approaches to handle parsing error.

## Requirements

Swift **3.0** , Xcode8

## Installation[WIP]

JUNSON is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JUNSON"
```

## Author

SatoshiN21, satoshi.nagasaka@eure.jp

## License

JUNSON is available under the MIT license. See the LICENSE file for more info.
