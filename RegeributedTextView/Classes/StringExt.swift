//
//  StringExt.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

extension String {
    var rangeOfCharacters: Range<String.Index> {
        // The range of self is always succeeded.
        return self.range(of: self)!
    }
    
    // Convert `Range` to `NSRange`
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    // Returns matched range list by regular expression.
    func matched(by regex: String) -> [Range<String.Index>] {
        let result = try? NSRegularExpression(pattern: regex, options: [])
            .matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
            .flatMap{ $0.rangeAt(0).range(for: self) }
        return result ?? []
    }
}
