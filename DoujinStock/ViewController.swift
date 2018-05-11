//
//  ViewController.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/02/13.
//

import UIKit

class ViewController: UIViewController {

  //@IBOutlet weak var titleLabel1: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
     // let title1: String = "鷺沢文香さん19歳"
      
      //titleLabel1.text = title1
        // Do any additional setup after loading the view, typically from a nib.
      view.addSubview(SwitcherView(frame: UIScreen.main.bounds))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

