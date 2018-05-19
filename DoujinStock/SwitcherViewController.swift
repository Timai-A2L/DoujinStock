//
//  SwitcherViewController.swift
//  DoujinStock
//
//  Created by 史翔新 on 2018/05/19.
//

import UIKit

class SwitcherViewController: UIViewController {
  
  private(set) var fullScreenContainerIndex: Int? = nil {
    didSet {
      do {
        try updateSwithcerViewWithFullScreenContainerIndex()
      } catch let error {
        assertionFailure("\(error)")
      }
    }
  }
  
  private(set) lazy var switcherView: SwitcherView = {
    let view = SwitcherView(frame: UIScreen.main.bounds)
    view.switcherDelegate = self
    return view
  }()
  
  override func loadView() {
    let view = switcherView
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Separate books to a model
    switcherView.addContainer(imageName: "image1.jpeg")
  }
  
}

extension SwitcherViewController {
  
  private func updateSwithcerViewWithFullScreenContainerIndex() throws {
    
    if let index = fullScreenContainerIndex {
      try switcherView.displayContainerViewInFullScreen(at: index, animated: true)
      
    } else {
      try switcherView.retractContainerViewFromFullScreen(animated: true)
    }
    
  }
  
}

extension SwitcherViewController: SwitcherViewDelegate {
  
  func switcherView(_ switcherView: SwitcherView, didTapOnContainer container: ContainerView, at index: Int) {
    
    if fullScreenContainerIndex == nil {
      fullScreenContainerIndex = index
      
    } else {
      fullScreenContainerIndex = nil
    }
    
  }
  
}
