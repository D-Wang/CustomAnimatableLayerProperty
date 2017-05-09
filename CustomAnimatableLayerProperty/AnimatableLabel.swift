//
//  AnimatableLabel.swift
//  CustomAnimatableLayerProperty
//
//  Created by WangWei on 2017/5/8.
//  Copyright © 2017年 Wang. All rights reserved.
//

import UIKit

class CustomLayer: CALayer {
    @NSManaged var toValue: CGFloat
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? CustomLayer {
            toValue = layer.toValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "toValue" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if event == "toValue" {
            if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
                animation.keyPath = event
                if let aLayer = presentation() {
                    animation.fromValue = aLayer.toValue
                }
                animation.toValue = nil
                return animation
            }
            setNeedsDisplay()
            return nil
        }
        return super.action(forKey: event)
    }
}

class AnimatableLabel: UIView {

    lazy var internalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    var percentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 3
        return view
    }()

    var toValue: CGFloat {
        set {
            (layer as? CustomLayer)?.toValue = newValue
        }
        get {
            return (layer as? CustomLayer)?.toValue ?? 0
        }
    }
    
    var formatBlock: ((CGFloat) -> Void)?

    override class var layerClass: AnyClass {
        return CustomLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInternalLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureInternalLabel()
    }

    fileprivate func configureInternalLabel() {
        addSubview(percentView)

        internalLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalLabel)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: ["label": internalLabel])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label": internalLabel])
        addConstraints([hConstraints, vConstraints].flatMap { $0 })
    }

    override func display(_ layer: CALayer) {
        if let animatedLayer = layer.presentation() as? CustomLayer {
            formatBlock?(animatedLayer.toValue)
            let width = frame.width * (animatedLayer.toValue / 100)
            percentView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        }
    }
}
