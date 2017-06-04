//
//  RegexStringConvertible.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

public protocol RegexStringConvertible {
    var string: String { get }
}

extension String: RegexStringConvertible {
    public var string: String {
        return self
    }
}

