//
//  SwitcherView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/04/30.
//

import UIKit

class SwitcherView: UIView, UIScrollViewDelegate {
  
  var scrollView: UIScrollView!
  var imageView: UIImageView!
  
  let angle: CGFloat = 55.0
  let scaleOut: CGFloat = 0.8
  
  var switcherViewPadding: CGFloat = 0.0
  let separatorDivisor: CGFloat = 3.0
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
    
    image = UIImage(named: imageName)
    imageView = UIImageView(image: image)
    imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    imageView.layer.transform = getTransform(translatedToX: 0, isScale:true, isRotate:true)
    
    switcherViewPadding = bounds.size.height / separatorDivisor
    scrollView = UIScrollView(frame: bounds)
    scrollView.isUserInteractionEnabled = true
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 1.0
    scrollView.isScrollEnabled = true
    scrollView.contentSize = CGSize(width: bounds.size.width+imageView.frame.size.width, height: bounds.size.height)
    scrollView.delegate = self
    
    
    addSubview(scrollView)
    scrollView.addSubview(imageView)
  }
  
  func radians(degree: CGFloat) -> CGFloat {
    return degree * CGFloat.pi / 180.0
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
      transform = CATransform3DTranslate(transform, 0.0, 0.0, translatedToX)
    }
    return transform
  }
  
}
