//
//  NSRangeExt.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

extension NSRange {
    // Convert `NSRange` to `Range` by text.
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound,
            let fromUTF = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex),
            let toUTF = str.utf16.index(fromUTF, offsetBy: length, limitedBy: str.utf16.endIndex),
            let from = String.Index(fromUTF, within: str),
            let to = String.Index(toUTF, within: str) else { return nil }
        return from ..< to
    }
}
