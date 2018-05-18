//
//  ViewController.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/02/13.
//

import UIKit

class ViewController: UIViewController {
  
  private lazy var switcherViewController: SwitcherViewController = .init(nibName: nil, bundle: nil)
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    present(switcherViewController, animated: false, completion: nil)
  }
  
}
