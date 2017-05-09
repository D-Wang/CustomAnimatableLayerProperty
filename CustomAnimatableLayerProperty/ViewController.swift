//
//  ViewController.swift
//  CustomAnimatableLayerProperty
//
//  Created by WangWei on 2017/5/8.
//  Copyright © 2017年 Wang. All rights reserved.
//

import UIKit

class PercentFormatter {
    
    func attributedString(fromValue value: CGFloat) -> NSAttributedString? {
        
        let rawString = String(format: "%.0f", value)
        let numberString = NSMutableAttributedString(string: rawString, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 36)])
        
        let percentString = NSAttributedString(string: "%", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        numberString.append(percentString)
        
        return numberString
    }
}

class ViewController: UIViewController {

    var animatableLabel: AnimatableLabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        animatableLabel = AnimatableLabel()
        animatableLabel?.translatesAutoresizingMaskIntoConstraints = false
        let percentFormatter = PercentFormatter()
        animatableLabel?.formatBlock = { [weak self] value in
            self?.animatableLabel?.internalLabel.attributedText = percentFormatter.attributedString(fromValue: value)
        }

        view.addSubview(animatableLabel!)
        view.addConstraint(NSLayoutConstraint(item: animatableLabel!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: animatableLabel!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: animatableLabel!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0))

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)

        view.addSubview(button)
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: animatableLabel!, attribute: .bottom, multiplier: 1.0, constant: 8))
    }

    func startAnimation() {
        animatableLabel?.toValue = 0
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
            self.animatableLabel?.toValue = 100
        }, completion: nil)
    }

}

