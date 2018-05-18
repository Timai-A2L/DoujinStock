//
//  SwitcherViewController.swift
//  DoujinStock
//
//  Created by 史翔新 on 2018/05/19.
//

import UIKit

class SwitcherViewController: UIViewController {
  
  override func loadView() {
    let view = SwitcherView(frame: UIScreen.main.bounds)
    self.view = view
  }
  
}
