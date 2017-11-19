//
//  RangeExt.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

extension Range where Bound == String.Index {
    // Returns `true` if the self range contains the offset.
    func constains(offset: String.IndexDistance, within text: String) -> Bool {
        let startIndex = text.startIndex
        let start = text.distance(from: startIndex, to: lowerBound)
        let end = text.distance(from: startIndex, to: upperBound)
        return offset >= start && offset <= end
    }
}
