//
//  RegexStringType.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

// Support type for easy highlight.
public enum RegexStringType: String {
    case all = ".*"
    case hashTag = "#[\\p{L}0-9_〜ー]+"
    case mention = "@[\\p{L}0-9_〜ー]+"
}

extension RegexStringType: RegexStringConvertible {
    public var string: String {
        return self.rawValue
    }
}
