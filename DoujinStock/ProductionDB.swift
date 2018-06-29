//
//  Realm.swift
//  DoujinStock
//
//  Created by Tomonari Imai on 2018/06/12.
//

import Foundation
import RealmSwift

class Production: Object {
  @objc dynamic var id:Int = 0
  @objc dynamic var productionName:String = ""
  @objc dynamic var author:String = ""
  @objc dynamic var coverImage:Data? = nil
  @objc dynamic var club:String = ""
  @objc dynamic var date:Date? = nil
  @objc dynamic var twitter:String? = nil
  @objc dynamic var pixiv:String? = nil
  @objc dynamic var blog:String? = nil
  @objc dynamic var mail:String? = nil
}

class ProductionDB {
  
  static let realm:Realm = try! Realm()
  
  init() {
  }
  
  
}
