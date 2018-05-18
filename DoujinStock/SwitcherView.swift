//
//  SwitcherView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/04/30.
//

import UIKit

class SwitcherView: UIView, UIScrollViewDelegate {
  
  static let enableUserInteractionInSwitcher = true
  
  var scrollView: UIScrollView!
  var imageView: UIImageView!
  var containerViews: [ContainerView] = []
  
  let angle: CGFloat = 55.0
  let scaleOut: CGFloat = 0.8
  
  var switcherViewPadding: CGFloat = 0.0
  let separatorDivisor: CGFloat = 3.0
  var saveContentSize: CGSize!
  
  var translationDivisor: CGFloat {
    get {
      if UIDevice.current.userInterfaceIdiom == .pad {
        return 4.46
      } else {
        return 4.13
      }
    }
  }
  
  let imageName: String = "image1.jpeg"
  var image: UIImage!
  

  override init(frame: CGRect) {
    super.init(frame: frame)
    standardInitialize()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)!
    standardInitialize()
  }
  
  func standardInitialize() {
    layer.backgroundColor = UIColor.darkGray.cgColor
    
    //image = UIImage(named: imageName)
    //imageView = UIImageView(image: image)
    //imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    //imageView.layer.transform = getTransform(translatedToX: 0, isScale:true, isRotate:true)
    
    switcherViewPadding = bounds.size.height / separatorDivisor
    scrollView = UIScrollView(frame: bounds)
    scrollView.isUserInteractionEnabled = true
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 1.0
    scrollView.isScrollEnabled = true
    scrollView.contentSize = CGSize(width: bounds.size.width, height: bounds.size.height)
    scrollView.delegate = self
    
    
    addSubview(scrollView)
    //scrollView.addSubview(imageView)
    
    addContainerView(ContainerView(frame: bounds,
                                   parentView: self,
                                   imageName: "image1.jpeg"))
  }
  
  func radians(degree: CGFloat) -> CGFloat {
    return degree * CGFloat.pi / 180.0
  }
  
  func addContainerView(_ view: ContainerView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.frame = CGRect(x: CGFloat(scrollView.subviews.count) * switcherViewPadding,
                        y: 0.0,
                        width: frame.size.width,
                        height: frame.size.height)
    scrollView.addSubview(view)
    view.index = containerViews.count
    containerViews.append(view)
    view.layer.transform = getTransform(translatedToX: 0, isScale: true, isRotate: true)
    scrollView.contentSize = CGSize(width: scrollView.contentSize.width + switcherViewPadding,
                                    height:scrollView.contentSize.height)
  }
  
  func getTransform(translatedToX: CGFloat, isScale: Bool, isRotate: Bool) -> CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -2000.0
    if isRotate {
      transform = CATransform3DRotate(transform, -radians(degree: angle), 1.0, 0.0, 0.0)
    }
    if isScale {
      transform = CATransform3DScale(transform, scaleOut, scaleOut, scaleOut)
    }
    if translatedToX != 0 {
      transform = CATransform3DTranslate(transform, translatedToX, 0.0, 0.0)
    }
    return transform
  }
  
  func animate(transform: CATransform3D, view: UIView) {
    let basicAnim = CABasicAnimation(keyPath: "transform")
    basicAnim.fromValue = view.layer.transform
    basicAnim.toValue = transform
    view.layer.add(basicAnim, forKey: nil)
    CATransaction.setDisableActions(true)
    view.layer.transform = transform
    CATransaction.setDisableActions(false)
  }
  
  func animate(view: ContainerView, isFullScreen: Bool) {
    if isFullScreen {
      for i in 0..<view.index {
        animate(transform: getTransform(translatedToX: -bounds.size.width, isScale: true, isRotate: false), view: containerViews[i])
      }
      animate(transform: getTransform(translatedToX: scrollView.contentOffset.x,
                                      isScale: false, isRotate: false), view: view)
      //saveContentSize = scrollView.contentSize
      //scrollView.contentSize = CGSize(width: bounds.size.width, height: bounds.size.height)
      for i in (view.index+1)..<containerViews.count {
        animate(transform: getTransform(translatedToX: 2.0 * bounds.size.width,
                                        isScale: true, isRotate: true), view: containerViews[i])
      }
    } else {
      for i in 0..<view.index {
        animate(transform: getTransform(translatedToX: 0.0,
                                        isScale: true, isRotate: true), view: containerViews[i])
      }
      animate(transform: getTransform(translatedToX: 0.0,
                                      isScale: true, isRotate: true), view: view)
      //scrollView.contentSize = saveContentSize
      for i in (view.index + 1)..<containerViews.count {
        animate(transform: getTransform(translatedToX: 0.0,
                                        isScale: true, isRotate: true), view: containerViews[i])
      }
    }
  }
}
