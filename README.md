# CRDatepicker

[![CI Status](https://img.shields.io/travis/chola/CRDatepicker.svg?style=flat)](https://travis-ci.org/chola/CRDatepicker)
[![Version](https://img.shields.io/cocoapods/v/CRDatepicker.svg?style=flat)](https://cocoapods.org/pods/CRDatepicker)
[![License](https://img.shields.io/cocoapods/l/CRDatepicker.svg?style=flat)](https://cocoapods.org/pods/CRDatepicker)
[![Platform](https://img.shields.io/cocoapods/p/CRDatepicker.svg?style=flat)](https://cocoapods.org/pods/CRDatepicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Screenshot

![crdatepickerscreen](https://user-images.githubusercontent.com/7077860/42502143-53f2a51e-8446-11e8-81fb-71627e63121c.png)


## Installation

CRDatepicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CRDatepicker'
```

How to use
----------

**STEP 1**:

Trigger Date picker
```swift
import CRDatepicker

let vc : CRDatepicker = CRDatepicker.create() as! CRDatepicker
vc.delegate = self
vc.showCRDate(obj: self)
```

**STEP 2**:

Date picker callback
```swift
CRDatepickerDelegate

func dateUpdate(_ strDate: String) {

}
```

## Author

chola, cholaitnj@gmail.com

## License

CRDatepicker is available under the MIT license. See the LICENSE file for more info.
