//
//  SwitcherView.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/04/30.
//

import UIKit

protocol SwitcherViewDelegate: class {
  func switcherView(_ switcherView: SwitcherView, didTapOnContainer container: ContainerView, at index: Int)
}

class SwitcherView: UIScrollView {
  
  weak var switcherDelegate: SwitcherViewDelegate?
  
  private weak var fullScreenContainerView: ContainerView?
  private(set) var containerViews: [ContainerView] = []
  
  private let thumbnailAngle: CGFloat = 55.0
  private let thumbnailScaleOut: CGFloat = 0.9
  
  private let separatorDivisor: CGFloat = 4.0
  private var switcherViewPadding: CGFloat {
    return bounds.width / separatorDivisor
  }
  
  enum ContainerViewFullScreenSettingError: Error {
    case tryingToFullscreenAnotherContainerViewWhileAlreadyAContainerViewInFullScreenMode
    case tryingToRetractWithoutButNoContainerViewIsInFullScreen
    case tryingToSetAContainerViewWhichIsNotInContainerViewsHierarchy
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    standardInitialize()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)!
    standardInitialize()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    for (i, container) in containerViews.enumerated() {
      let shouldLayoutAsThumbnail = !(container == fullScreenContainerView)
      layoutContainer(container, at: i, asThumbnail: shouldLayoutAsThumbnail)
    }
    
    updateContentSize()
    
  }
  
}

extension SwitcherView {
  
  private func standardInitialize() {
    
    layer.backgroundColor = UIColor.darkGray.cgColor
    isUserInteractionEnabled = true
    minimumZoomScale = 1.0
    maximumZoomScale = 1.0
    isScrollEnabled = true
    
  }
  
  private func getContainerFrame(at index: Int, isForThumbnail: Bool) -> CGRect {
    
    if isForThumbnail {
//      let containerX: CGFloat = CGFloat(index) * (bounds.width + switcherViewPadding)
      let containerX: CGFloat = CGFloat(index) * switcherViewPadding
      let containerOrigin: CGPoint = .init(x: containerX, y: 0)
      return .init(origin: containerOrigin, size: bounds.size)
      
    } else {
//      return bounds
      return CGRect(x: bounds.minX, y: bounds.minY, width: bounds.size.width, height: bounds.size.height)
    }
    
  }
  
  private func getContainerTransform(isForThumbnail: Bool) -> CATransform3D {
    
    var baseTransform = CATransform3DIdentity
    
    if isForThumbnail {
      baseTransform.m34 = 1.0 / -2000.0
      baseTransform = CATransform3DRotate(baseTransform, 1.0, 0.0, -thumbnailAngle.toRadians, 0.0)
      baseTransform = CATransform3DScale(baseTransform, thumbnailScaleOut, thumbnailScaleOut, thumbnailScaleOut)
      
    } else {
      // Do nothing, just return the identity transform
    }
    
    return baseTransform
  }
  
  private func setIsHidden(at index: Int, isForThumbnail: Bool) {
    if isForThumbnail {
      for viewCount in 0 ..< containerViews.count {
        containerViews[viewCount].isHidden = false
      }
    } else {
      for viewCount in 0 ..< containerViews.count {
        if viewCount != index {
          containerViews[viewCount].isHidden = true
        }
      }
    }
  }
  
  private func layoutContainer(_ containerView: UIView, at index: Int, asThumbnail: Bool) {
    
    let containerFrame = getContainerFrame(at: index, isForThumbnail: asThumbnail)
    let containerLayerTransform = getContainerTransform(isForThumbnail: asThumbnail)
    containerView.frame = containerFrame
    containerView.layer.transform = containerLayerTransform
    
  }
  
  private func updateContentSize() {
    
    let containersSize = containerViews.reduce(into: CGSize()) { (result, container) in
      result.width = max(result.width, container.frame.maxX)
      result.height = max(result.height, container.frame.maxY)
    }
    
    contentSize = containersSize
    
  }
  
}

extension SwitcherView {
  
  func addContainer(imageName: String) {
    
    let containerView = ContainerView(imageName: imageName)
//    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.delegate = self
    
    addSubview(containerView)
    sendSubview(toBack: containerView)
    containerViews.append(containerView)
    
  }
  
  func displayContainerViewInFullScreen(at index: Int, animated: Bool) throws {
    
    guard fullScreenContainerView == nil else {
      throw ContainerViewFullScreenSettingError.tryingToFullscreenAnotherContainerViewWhileAlreadyAContainerViewInFullScreenMode
    }
    
    guard containerViews.indices.contains(index) else {
      throw ContainerViewFullScreenSettingError.tryingToSetAContainerViewWhichIsNotInContainerViewsHierarchy
    }
    
    let containerView = containerViews[index]
    fullScreenContainerView = containerView
    
    let asThumbnail = false
    
    if animated {
      UIView.animate(withDuration: 0.3) {
        self.layoutContainer(containerView, at: index, asThumbnail: asThumbnail)
      }
      
    } else {
      layoutContainer(containerView, at: index, asThumbnail: asThumbnail)
    }
    
    setIsHidden(at: index, isForThumbnail: asThumbnail)
    
  }
  
  func retractContainerViewFromFullScreen(animated: Bool) throws {
    
    guard let containerView = fullScreenContainerView else {
      throw ContainerViewFullScreenSettingError.tryingToRetractWithoutButNoContainerViewIsInFullScreen
    }
    
    guard let index = containerViews.index(of: containerView) else {
      throw ContainerViewFullScreenSettingError.tryingToSetAContainerViewWhichIsNotInContainerViewsHierarchy
    }
    
    fullScreenContainerView = nil
    
    let asThumbnail = true
    
    if animated {
      UIView.animate(withDuration: 0.3) {
        self.layoutContainer(containerView, at: index, asThumbnail: asThumbnail)
      }
      
    } else {
      layoutContainer(containerView, at: index, asThumbnail: asThumbnail)
    }
    
    setIsHidden(at: index, isForThumbnail: asThumbnail)
  }
  
}

extension SwitcherView: ContainerViewDelegate {
  
  func containerViewDidTap(_ containerView: ContainerView) {
    
    guard let switcherDelegate = self.switcherDelegate else {
      assertionFailure("switcher delegate is not set yet")
      return
    }
    
    guard let index = containerViews.index(of: containerView) else {
      assertionFailure("ContainerView \(containerView) has not been added to the container view hierarchy yet.")
      return
    }
    
    switcherDelegate.switcherView(self, didTapOnContainer: containerView, at: index)
    
  }
  
}

private extension CGFloat {
  
  var toRadians: CGFloat {
    return self * .pi / 180
  }
  
}
