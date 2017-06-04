//
//  RegeributedTextViewProtocol.swift
//  Pods
//
//  Created by 石川 諒 on 2017/06/04.
//
//

import UIKit

// MARK: - UITextViewDelegate
protocol RegeributedTextViewDelegate: UITextViewDelegate {
    
   /*
    * This will call when you select an attributed text.
    * - didSelect text: Tapped attributed text
    * - attributes: An attribute list that you seted to the text. 
    */
    func regeributedTextView(_ textView: RegeributedTextView, didSelect text: String, values: [String: Any])
    
   /*
    * This will call when an attributed text is changed.
    */
    func regeributedTextViewDidChange(_ textView: RegeributedTextView)
    
}

// For make optional delegate method.
extension RegeributedTextViewDelegate {
    
    func regeributedTextView(_ textView: RegeributedTextView, didSelect text: String, values: [String: Any]) {}
    
    func regeributedTextViewDidChange(_ textView: RegeributedTextView) {}
    
}

