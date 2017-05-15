# CustomAnimatableLayerProperty ####

This demo shows how to add custom animatable property to CALayer, which can be animated in UIView animation block with system supported options like `.curveEaseInOut`.
```
UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
    self.animatableLabel?.toValue = 100
}, completion: nil)
```