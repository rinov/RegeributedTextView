//
//  ViewController.swift
//  RegeributedTextView
//
//  Created by rinov on 06/04/2017.
//  Copyright (c) 2017 rinov. All rights reserved.
//

import UIKit
import RegeributedTextView

class ViewController: UIViewController {

    @IBOutlet weak var selectedLabel: UILabel!

    @IBOutlet weak var textView: RegeributedTextView! {
        didSet {
            textView.delegate = self
        }
    }

    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.value = 0
            slider.addTarget(self, action: #selector(didSlide(_:)), for: .valueChanged)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedClear(_ sender: Any) {
        textView.removeAllAttribute()
        selectedLabel.text = "None"
    }

    @IBAction func tappedMention(_ sender: Any) {
        textView.addAttribute(.mention, attribute: .textColor(.blue))
    }

    @IBAction func tappedHashTag(_ sender: Any) {
        textView.addAttribute(.hashTag, attribute: .textColor(.purple), values: ["URL": "https://google.com"])
    }

    @IBAction func tappedUnderline(_ sender: Any) {
        textView.addAttribute(.all, attribute: .underline(.double))
    }

    @IBAction func tappedBold(_ sender: Any) {
        textView.addAttribute(.all, attribute: .bold)
    }

    @IBAction func tappedFontName(_ sender: Any) {
        textView.addAttribute(.all, attribute: .fontName("Zapfino"))
    }

    @IBAction func tappedItalic(_ sender: Any) {
        textView.addAttribute("Hello", attribute: .italic(1.2))
    }

    @objc func didSlide(_ sender: UISlider) {
        let value = CGFloat(slider.value + 1.0)
        let currentFontSize = textView.font!.pointSize
        textView.addAttribute("[#@]", attribute: .fontSize(currentFontSize * value))
    }

}

extension ViewController: RegeributedTextViewDelegate {

    func regeributedTextView(_ textView: RegeributedTextView, didSelect text: String, values: [String : Any]) {
        print("Selected word: \(text)")
        selectedLabel.text = text

        // You can get the emmbeded url from values
        if let url = values["URL"] as? String {
            // e.g.
            // UIApplication.shared.openURL(URL(string: url)!)
        }
   }

}
