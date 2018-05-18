//
//  ContainerView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/05/09.
//

import UIKit

class ContainerView: UIView, UIGestureRecognizerDelegate {
  
  var saveOriginX: CGFloat = 0.0
  var parentView: SwitcherView
  var isFullScreen: Bool = false
  var index: Int = 0
  var savedTranform: CATransform3D = CATransform3DIdentity
  var tapRecognizer: UITapGestureRecognizer!
  
  convenience init(frame: CGRect, parentView: SwitcherView, imageName: String) {
    self.init(frame: frame, parentView: parentView)
    self.layer.contents = UIImage(named: imageName)!.cgImage!
  }
  
  init(frame: CGRect, parentView: SwitcherView) {
    self.parentView = parentView
    super.init(frame: frame)
    self.parentView = parentView
    saveOriginX = frame.origin.x
    
    tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleAnimation))
    tapRecognizer.numberOfTapsRequired = 1
    
    addGestureRecognizer(tapRecognizer)
    tapRecognizer.delegate = self
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shadowRadius = 20.0
    
    layer.edgeAntialiasingMask = CAEdgeAntialiasingMask(rawValue:
    CAEdgeAntialiasingMask.layerLeftEdge.rawValue |
    CAEdgeAntialiasingMask.layerRightEdge.rawValue |
    CAEdgeAntialiasingMask.layerBottomEdge.rawValue |
    CAEdgeAntialiasingMask.layerTopEdge.rawValue)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith shouldRecognizeSimulataneouslyWithGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  @objc func toggleAnimation() {
    isFullScreen = !isFullScreen
    parentView.animate(view: self, isFullScreen: isFullScreen)
    parentView.isScrollEnabled = !isFullScreen
    if !SwitcherView.enableUserInteractionInSwitcher {
      for subView in subviews {
        subView.isUserInteractionEnabled = isFullScreen
      }
    }
  }
}
