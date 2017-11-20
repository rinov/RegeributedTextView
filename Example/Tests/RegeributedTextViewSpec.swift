//
//  RegeributedTextViewSpec.swift
//  RegeributedTextView
//
//  Created by 石川 諒 on 2017/06/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//
import Quick
import Nimble
import RegeributedTextView

class RegeributedTextViewSpec: QuickSpec {
    override func spec() {

        context("text is nil") {
            let tv = RegeributedTextView()
            beforeEach {
                tv.text = nil
            }
            it("will be empty") {
                expect(tv.text).to(equal(""))
            }
        }

        context("text is empty") {
            let tv = RegeributedTextView()
            beforeEach {
                tv.text = ""
            }
            it("will be empty") {
                expect(tv.text).to(equal(""))
            }
        }

        context("There are text") {
            let tv = RegeributedTextView()
            beforeEach {
                tv.text = "abcde1234 @mention #hash $unknown¥^-[@]:;_/.,!#$%&'()0'=~|{`}*+_?><"
            }
            describe("Text property") {
                it("always equals the text") {
                    expect(tv.text).to(equal("abcde1234 @mention #hash $unknown¥^-[@]:;_/.,!#$%&'()0'=~|{`}*+_?><"))
                }
                it("is same characters count") {
                    expect(tv.text.count).to(equal("abcde1234 @mention #hash $unknown¥^-[@]:;_/.,!#$%&'()0'=~|{`}*+_?><".count))
                }
            }
            describe("RegexStringType.mention") {
                beforeEach {
                    tv.text = "abcde1234 @mention #hash $unknown¥^-[@]:;_/.,!#$%&'()0'=~|{`}*+_?><"
                    tv.removeAllAttribute()
                    tv.addAttribute(RegexStringType.mention, attribute: .textColor(.red))
                }
                it("hasn't text color attribute") {
                    let attr = tv.attributedText.attributes(at: 9, effectiveRange: nil)
                    expect(attr[.foregroundColor] as? UIColor).to(beNil())
                }
                it("has text color attribute") {
                    let attr = tv.attributedText.attributes(at: 13, effectiveRange: nil)
                    expect(attr[.foregroundColor] as? UIColor).toNot(beNil())
                }
            }
            describe("RegexStringType.hashTag") {
                beforeEach {
                    tv.text = "abcde1234 @mention #hash $unknown¥^-[@]:;_/.,!#$%&'()0'=~|{`}*+_?><"
                    tv.removeAllAttribute()
                    tv.addAttribute(RegexStringType.hashTag, attribute: .backgroundColor(.blue))
                }
                it("hasn't text color attribute") {
                    let attr = tv.attributedText.attributes(at: 18, effectiveRange: nil)
                    expect(attr[.foregroundColor] as? UIColor).to(beNil())
                }

                it("has text color attribute") {
                    let attr = tv.attributedText.attributes(at: 19, effectiveRange: nil)
                    expect(attr[.backgroundColor] as? UIColor).to(equal(UIColor.blue))
                }
            }
            describe("Emmbeded values") {
                beforeEach {
                    let emmbededInt: Int = 1001
                    let emmbededDouble: Double = 0.1001
                    let emmbededString: String = "1001"
                    let emmbededFloat: Float = 0.1001
                    let emmbededBool: Bool = true
                    tv.addAttribute("abcde", attribute: .textColor(.green), values: ["Int": emmbededInt, "Double": emmbededDouble, "String": emmbededString, "Float": emmbededFloat, "Bool": emmbededBool])
                }
                it("has five keys") {
                    expect(tv.attributes.count).to(equal(5))
                }
                it("can get int value") {
                    expect(tv.attributes["Int"] as? Int) == 1001
                }
                it("can get double value") {
                    expect(tv.attributes["Double"] as? Double) == 0.1001
                }
                it("can get string value") {
                    expect(tv.attributes["String"] as? String) == "1001"
                }
                it("can get float value") {
                    expect(tv.attributes["Float"] as? Float) == 0.1001
                }
                it("can get bool value") {
                    expect(tv.attributes["Bool"] as? Bool) == true
                }
            }
            describe("Remove attributes") {
                beforeEach {
                    tv.removeAllAttribute()
                    let emmbededInt: Int = 1001
                    let emmbededString: String = "2002"
                    tv.addAttribute("abcde", attribute: .textColor(.red), values: ["Int": emmbededInt, "String": emmbededString])
                }
                it("has two keys") {
                    expect(tv.attributes.count).to(equal(2))
                }
                context("Remove Int key") {
                    beforeEach {
                        tv.removeAttribute(key: "Int")
                    }
                    it("has one key") {
                        expect(tv.attributes.count).to(equal(1))
                    }
                }
            }
        }
    }
}
