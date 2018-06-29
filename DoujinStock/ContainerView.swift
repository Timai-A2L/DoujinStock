//
//  ContainerView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/05/09.
//

import UIKit
import AVFoundation

protocol ContainerViewDelegate: class {
  func containerViewDidTap(_ containerView: ContainerView)
}

class ContainerView: UIView {
  
  weak var delegate: ContainerViewDelegate?
  
  let imageView:UIImageView! = UIImageView()
  
  convenience init(imageName: String) {
    self.init(frame: .zero, imageName: imageName)
  }
  
  init(frame: CGRect, imageName: String) {
    
    super.init(frame: frame)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
    tapRecognizer.numberOfTapsRequired = 1
    addGestureRecognizer(tapRecognizer)
    
    imageView.image = UIImage(named:imageName)
    imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    addSubview(imageView)
    
    
//    if let layerContent = UIImage(named:imageName)?.cgImage {
//      layer.contents = layerContent
//    }
    let imageSize: CGRect = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: imageView.bounds)

    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.shadowOpacity = 0.5
    imageView.layer.shadowPath = UIBezierPath(rect: CGRect(x: imageSize.minX, y: imageSize.minY,
                                                           width: imageSize.size.width + 30, height: imageSize.size.height + 20)).cgPath
    imageView.layer.shadowRadius = 20.0
    imageView.layer.edgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func didTap(sender: UITapGestureRecognizer) {
    
    guard let delegate = self.delegate else {
      assertionFailure("delegate is not set yet")
      return
    }
    
    delegate.containerViewDidTap(self)
    
  }
  
}
