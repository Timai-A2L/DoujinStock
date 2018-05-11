//
//  ContainerView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/05/09.
//

import UIKit

class ContainerView: UIView, UIGestureRecognizerDelegate {
  
  var saveOriginY: CGFloat = 0.0
  var parentView: SwitcherView
  var isFullScreen: Bool = false
  var index: Int = 0
  var tapRecognizer: UITapGestureRecognizer!
  
  init(frame: CGRect, parentView: SwitcherView) {
    self.parentView = parentView
    super.init(frame: frame)
    self.parentView = parentView
    saveOriginY = frame.origin.y
    
    tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleAnimation))
    tapRecognizer.numberOfTapsRequired = 1
    
    addGestureRecognizer(tapRecognizer)
    tapRecognizer.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func toggleAnimation() {
    isFullScreen = !isFullScreen
    parentView.animate(view: self, isFullScreen: isFullScreen)
    parentView.scrollView.isScrollEnabled = !isFullScreen
    if !SwitcherView.enableUserIntaractionInSwitcher {
      for subView in subviews {
        subView.isUserInteractionEnabled = isFullScreen
      }
    }
  }
}
