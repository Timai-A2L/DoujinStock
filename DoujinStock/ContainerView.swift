//
//  ContainerView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/05/09.
//

import UIKit

protocol ContainerViewDelegate: class {
  func containerViewDidTap(_ containerView: ContainerView)
}

class ContainerView: UIView {
  
  weak var delegate: ContainerViewDelegate?
  
  convenience init(imageName: String) {
    self.init(frame: .zero, imageName: imageName)
  }
  
  init(frame: CGRect, imageName: String) {
    
    super.init(frame: frame)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
    tapRecognizer.numberOfTapsRequired = 1
    addGestureRecognizer(tapRecognizer)
    
    if let layerContent = UIImage(named: imageName)?.cgImage {
      layer.contents = layerContent
    }
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shadowRadius = 20.0
    layer.edgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
    
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
