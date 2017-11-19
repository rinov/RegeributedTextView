//
//  ArrayExt.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

extension Array {
    // For handling swift3 type infference bug.
    // ISSUE: https://bugs.swift.org/browse/SR-1856
    func prefixed(_ maxLength: Int) -> [Element] {
        let result = prefix(maxLength)
        return result.map{ $0 }
    }
    
    func suffixed(_ maxLength: Int) -> [Element] {
        let result = suffix(maxLength)
        return result.map{ $0 }
    }
}
