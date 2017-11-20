# RegeributedTextView
[![Build Status](https://www.bitrise.io/app/734bd7a1b4b13c20/status.svg?token=azRrRGbppYpw5SWMyCMP_w&branch=master)](https://www.bitrise.io/app/734bd7a1b4b13c20)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)
[![License](https://img.shields.io/badge/LICENSE-MIT-yellow.svg)](https://img.shields.io/badge/LICENSE-MIT-yellow.svg)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
[![Language](https://img.shields.io/badge/Language-Swift4-blue.svg)

`RegeributedTextView` is a subclass of `UITextView` that supports fully attribute string based on regular expression.

[![DEMO](https://github.com/rinov/RegeributedTextView/blob/master/Images/sample1.gif)](https://github.com/rinov/RegeributedTextView/blob/master/Images/sample1.gif)

## Usage

```swift
import RegeributedTextView
```

and you can use `RegeributedTextView` as subclass of `UITextView` in Interface Builder.

[![InterfaceBuilder](https://github.com/rinov/RegeributedTextView/blob/master/Images/interface-builder.png)](https://github.com/rinov/RegeributedTextView/blob/master/Images/interface-builder.png)

It is simple to use an attribute string.

Chage the text color:

```swift
textView.addAttribute(.all, attribute: .textColor(.red)))
```

Instead of `.all`, you can use regular expression .

```swift
textView.addAttribute(".*", attribute: .textColor(.red)))
```

If you want highlight a mention and hash tag like a SNS, you can use following parameters.

```swift
textView.addAttribute(.mention, attribute: .bold))
textView.addAttribute(.hashTag, attribute: .textColor(.blue)))
```

## Available attribute type

| Attribute | Type |
|:-----------|:------------|
| backgroundColor     | UIColor        |
| bold                | -              |
| boldWithFontSize    | CGFloat        |
| font                | UIFont         |
| fontName            | String         |
| fontSize            | CGFloat        |
| italic              | CGFloat        |
| linkColor           | UIColor        |
| shadow              | Shadow         |
| strikeColor         | UIColor        |
| strikeWithThickness | CGFloat        |
| strokeWidth         | CGFloat        |
| textColor           | UIColor        |
| underline           | UnderlineStyle |
| underlineColor      | UIColor        |

## Link text behavior

In swift 4, The property `linkTextAttributes ` of `UITextView` can designate the link text behavior but it is not possible to coloring a few text separately in the same text.
In this case, you can use attributes text based on regular expression like this.

e.g. Set text color separately.

```swift
textView.addAttribute("@[a-zA-Z0-9]+", attributes: [.textColor(.black), .bold], values: ["Type": "Mention"])
textView.addAttribute("#[a-zA-Z0-9]+", attribute: .textColor(.blue), values: ["Type": "HashTag"])

```
In `RegeributedTextView`, All attributed text can be detected for each word by tapping.
and you can detect a tap event of link text by `RegeributedTextViewDelegate`.
The arguments of `values` can embbed any values.

```swift
func regeributedTextView(_ textView: RegeributedTextView, didSelect text: String, values: [String : Any]) {
    print("Selected word: \(text)")
    if let url = values["Type"] as? String {
        // Do something
    }
```

## Advanced settings

```swift
public func addAttribute(_ regexString: String, attribute: TextAttribute, values: [String: Any] = [:], priority: Priority = .medium, applyingIndex: ApplyingIndex = .all)
```

To control an attribute text, you can use `Prioriry` and `ApplyingIndex`.
`Priority` represents that attribute string priority.
Attribute text range is sometime overlaped, so this property enable to control attribute string priority like `AutoLayout`.

Rules:
- The new attribute priority is greater than the current attribute, it's overwriten.
- The new attribute priority is less than the current attribute, it's ignored.

`Applying Index` represents which text should be applied an attribute because it is difficult to control the attribute text order using only regular expression.

e.g. Applying only first element
```swift
let userName = "rinov"
textView.addAttribute(userName, attribute: .bold, applyingIndex: .first)
```

`ApplyingIndex` is available following patterns.

| ApplyingIndex | Description |
|:-----------|:------------|
| all                 | All matched text is applyed                                                |
| first               | Only first element is applyed                                              |
| firstFrom(Int)      |It's applyed for specified number of times from the start index of the text |
| ignoreFirstFrom(Int)| It's ignore for specified number of  times from the start index of the text|
| last                | Only last element is applyed                                               |
| lastFrom(Int)       | It's applyed for specified number of  times from the end index of the text |
| ignoreLastFrom(Int) | It's ignore for specified number of  times from the end index of the text  |
| indexOf(Int)        |  Applyed only specified index                                              |
| ignoreIndexOf(Int)  | Ignore only specified index                                                |

## Requirements

Swift 4

XCode 9

## Installation

Cocoapods: 

`$: pod repo update`

```ruby
pod "RegeributedTextView"
```

- Swift3.x: `pod "RegeributedTextView" , '~> 0.1.1'`

- Swift4.x: `pod "RegeributedTextView" , '~> 0.2.1'`

and

`$: pod install`

or 

Carthage:

```ruby
github "rinov/RegeributedTextView"
```

and

`$: carthage update --platform iOS`

## Author

rinov, rinov@rinov.jp

## License

RegeributedTextView is available under the MIT license. See the LICENSE file for more info.
