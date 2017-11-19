//
//  RegeributedTextView.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

import Foundation
import UIKit

/* This class is a subclass of `UITextView`.
 * - You can set a custom class to `RegeributedTextView` in the InterfaceBuilder.
 * - You can create your own custom `UITextView` using this class as it's base class.
 */
open class RegeributedTextView: UITextView {
    
    // The list of attribute values.
    public enum TextAttribute {
        case backgroundColor(UIColor)
        case bold
        case boldWithFontSize(CGFloat)
        case font(UIFont)
        case fontName(String)
        case fontSize(CGFloat)
        case italic(CGFloat)
        case linkColor
        case shadow(Shadow)
        case strikeColor(UIColor)
        case strikeWithThickness(CGFloat)
        case strokeWidth(CGFloat)
        case textColor(UIColor)
        case underline(UnderlineStyle)
        case underlineColor(UIColor)
        
        fileprivate func attributedValue(_ currentFont: UIFont?) -> [String: Any] {
            switch self {
            case .backgroundColor(let color):
                return [NSBackgroundColorAttributeName: color]
            case .bold:
                guard let font = currentFont else { return [:] }
                return [NSFontAttributeName: UIFont.boldSystemFont(ofSize: font.pointSize)]
            case .boldWithFontSize(let size):
                return [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)]
            case .font(let font):
                return [NSFontAttributeName: font]
            case .fontName(let name):
                guard let current = currentFont,
                    let font = UIFont(name: name, size: current.pointSize) else { return [:] }
                return [NSFontAttributeName: font]
            case .fontSize(let size):
                guard let current = currentFont,
                    let font = UIFont(name: current.fontName, size: size) else { return [:] }
                return [NSFontAttributeName: font]
            case .italic(let value):
                return [NSObliquenessAttributeName: value]
            case .linkColor:
                return [NSForegroundColorAttributeName: UIColor.blue]
            case .shadow(let shadow):
                return [NSShadowAttributeName: shadow]
            case .strikeColor(let color):
                return [NSStrikethroughColorAttributeName: color]
            case .strikeWithThickness(let value):
                return [NSStrikethroughStyleAttributeName: value]
            case .strokeWidth(let value):
                return [NSStrokeWidthAttributeName: value]
            case .textColor(let color):
                return [NSForegroundColorAttributeName: color]
            case .underline(let style):
                return [NSUnderlineStyleAttributeName: style.value]
            case .underlineColor(let color):
                return [NSUnderlineColorAttributeName: color]
            }
        }
    }
    
    /*
    * `Priority` represents text attribute priority. You can use priority when adding an attribute if needed.
    * Rules:
    * - The new attribute priority is greater than the current attribute, it's overwriten.
    * - The new attribute priority is less than the current attribute, it's ignored.
    * Default value is `medium`.
    */
    public enum Priority: Int {
        case required = 1000
        case high     = 900
        case medium   = 750
        case low      = 250
        
        public static func == (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        public static func < (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        public static func > (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.rawValue > rhs.rawValue
        }
        
        public static func <= (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.rawValue <= rhs.rawValue
        }
        
        public static func >= (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.rawValue >= rhs.rawValue
        }
    }
    
    /* 
    * `ApplyingIndex` represents that the attribute scope.
    * e.g. Applying attribute except the first matching element.
    * `ApplyingIndex.ignoreFirstFrom(1)`
    *  Default value is `all`. This mean all matched text is applyed the attribute.
    */
    public enum ApplyingIndex {
        
        // All matched text is applyed.
        case all
        
        // Only first element is applyed.
        case first
        
        // It's applyed for specified number of  times from the start index of the text.
        case firstFrom(Int)
        
        // It's ignore for specified number of  times from the start index of the text.
        case ignoreFirstFrom(Int)
        
        // Only last element is applyed.
        case last
        
        // It's applyed for specified number of  times from the end index of the text.
        case lastFrom(Int)
        
        // It's ignore for specified number of  times from the end index of the text.
        case ignoreLastFrom(Int)
        
        // Applyed only specified index.
        case indexOf(Int)
        
        // Ignore only specified index.
        case ignoreIndexOf(Int)
    }
    
    // MARK: - Private Properties
    
    fileprivate var tapAttributedTextGesture: UITapGestureRecognizer?
    
    private var _delegate: RegeributedTextViewDelegate?
    
    private var attributedRanges: [AttributedRange] = [] {
        didSet {
            _delegate?.regeributedTextViewDidChange(self)
        }
    }
    
    override open weak var delegate: UITextViewDelegate? {
        get {
            return _delegate
        }
        set {
            super.delegate = newValue
            _delegate = newValue as? RegeributedTextViewDelegate
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /* Add a new attribute to attributedText.
    * Properties:
    * - regexString: Regular expression string.
    * - attribute: A new text attribute
    * - value: An embedded value and you can detect the value if a user tapped the attributed text by delegate method.
    * - priority: An attribute priority. 
    * - applyingIndex: An applying element that you can specify.
    */
    public func addAttribute(_ regexString: String, attribute: TextAttribute, values: [String: Any] = [:], priority: Priority = .medium, applyingIndex: ApplyingIndex = .all) {
        let matched = text.matched(by: regexString)
        guard !matched.isEmpty,
            let attributedString = attributedText.mutableCopied() else { return }
        arranged(matched, orderBy: applyingIndex).forEach { range in
            let overlapedAttributes = attributedRanges.enumerated().filter { $0.element.range.overlaps(range) }
            // Remove overlaped text attribute if the current attribute priority is less or equal than `priority`.
            overlapedAttributes
                .filter { $0.element.priority < priority }
                .forEach { attribute in
                    attribute.element.attributeNames.forEach {
                        attributedString.removeAttribute($0, range: text.nsRange(from: attribute.element.range))
                    }
                    attributedRanges.remove(at: attribute.offset)
            }
            let higherAttributes = overlapedAttributes.filter { $0.element.priority > priority }
            if higherAttributes.isEmpty {
                var attribute = attribute.attributedValue(font)
                attribute[Constants.Meta.AttributeKey.rawValue] = values
                attributedString.addAttributes(attribute, range: text.nsRange(from: range))
                attributedRanges.append(AttributedRange(attributeNames: attribute.keys.map{ String($0) }, priority: priority, range: range))
            }
        }
        attributedText = attributedString
    }

    public func addAttribute(_ regexType: RegexStringType, attribute: TextAttribute, values: [String: Any] = [:], priority: Priority = .medium, applyingIndex: ApplyingIndex = .all) {
        addAttribute(regexType.rawValue, attribute: attribute, values: values, priority: priority, applyingIndex: applyingIndex)
    }

    /* Add a new attributes to attributedText.
     * Properties:
     * - regexStrong: Regular expression string or `RegexStringType`.
     * - attributes: A new text attributes that you can set like this. [.textColor(.red), .bold, backgroundColor(.clear)]
     * - value: An embedded value and you can detect the value if a user tapped the attributed text by delegate method.
     * - priority: An attribute priority.
     * - applyingIndex: An applying element that you can specify.
     */
    public func addAttributes(_ regexString: RegexStringConvertible, values: [String: Any] = [:], attributes: [TextAttribute], priority: Priority = .medium, applyingIndex: ApplyingIndex = .all) {
        attributes.forEach {
            addAttribute(regexString.string, attribute: $0, values: values, priority: priority, applyingIndex: applyingIndex)
        }
    }
    
    // Remove a matched text and update the text appearance.
    public func removeAttributes(_ regexString: RegexStringConvertible) {
        let matched = text.matched(by: regexString.string)
        guard let attributedString = attributedText.mutableCopied() else { return }
        attributedRanges.enumerated()
            .filter { attribute in
                let overlaped = matched.filter { $0.overlaps(attribute.element.range) }
                return !overlaped.isEmpty
            }
            .forEach {
                let range = text.nsRange(from: $0.element.range)
                $0.element.attributeNames.forEach { attributedString.removeAttribute($0, range: range) }
                attributedRanges.remove(at: $0.offset)
        }
        attributedText = attributedString
    }
    
    // Remove all attirbutes and update the text appearance.
    public func removeAllAttribute() {
        guard let attributedString = attributedText.mutableCopied() else { return }
        attributedRanges.forEach { attribute in
            attribute.attributeNames.forEach {
                attributedString.removeAttribute($0, range: text.nsRange(from: attribute.range))
            }
        }
        attributedText = attributedString
        attributedRanges.removeAll()
    }
    
    public func tappedAttributedText(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        guard let index = closestPosition(to: location) else { return }
        let offset = self.offset(from: beginningOfDocument, to: index)
        let attribute = attributedRanges.filter { NSLocationInRange(offset, self.text.nsRange(from: $0.range)) }.sorted { $0 > $1 }.first
        guard let selectedRange = attribute?.range,
            let names = attribute?.attributeNames,
            let value = attributedText.attribute(at: offset, attributeNames: names) else { return }
        _delegate?.regeributedTextView(self, didSelect: text.substring(with: selectedRange), values: value)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension RegeributedTextView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Private Extension
extension RegeributedTextView {
    
    fileprivate struct AttributedRange: Equatable {
        let attributeNames: [String]
        let priority: Priority
        let range: Range<String.Index>
        
        static func == (lhs: AttributedRange, rhs: AttributedRange) -> Bool {
            return lhs.priority.rawValue == rhs.priority.rawValue && lhs.range == rhs.range
        }
        
        static func < (lhs: AttributedRange, rhs: AttributedRange) -> Bool {
            return lhs.priority.rawValue < rhs.priority.rawValue
        }
        
        static func > (lhs: AttributedRange, rhs: AttributedRange) -> Bool {
            return lhs.priority.rawValue > rhs.priority.rawValue
        }
    }
    
    fileprivate struct Constants {
        enum Meta: String {
            case AttributeKey
            case AttributeName
        }
    }

    fileprivate func commonInit() {
        tapAttributedTextGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAttributedText(_:)))
        tapAttributedTextGesture?.delegate = self
        addGestureRecognizer(tapAttributedTextGesture!)
    }
    
    fileprivate func arranged(_ matches: [Range<String.Index>], orderBy: ApplyingIndex) -> [Range<String.Index>] {
        switch orderBy {
        case .first:
            return matches.prefixed(1).map { $0 }
        case .firstFrom(let n):
            return matches.prefixed(n).map { $0 }
        case .ignoreFirstFrom(let n):
            return matches.dropFirst(n).map { $0 }
        case .last:
            return matches.suffixed(1).map { $0 }
        case .lastFrom(let n):
            return matches.suffixed(n).map { $0 }
        case .ignoreLastFrom(let n):
            return matches.reversed().dropFirst(n).map { $0 }
        case .indexOf(let i):
            return i < matches.count && i >= 0 ? [matches[i]] : []
        case .ignoreIndexOf(let i):
            return matches.enumerated().filter { $0.offset != i }.map { $0.element }
        default:
            return matches
        }
    }
}

extension NSAttributedString {
    fileprivate func mutableCopied() -> NSMutableAttributedString? {
        return mutableCopy() as? NSMutableAttributedString
    }
    fileprivate func attribute(at offset: Int, attributeNames: [String]) -> [String: Any]? {
        return attribute(RegeributedTextView.Constants.Meta.AttributeKey.rawValue, at: offset, effectiveRange: nil) as? [String: Any]
    }
}
