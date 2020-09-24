//
//  RSSPointCellData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class RSSPointCellData: RSSPointProtocol {
  
  let url: URL
  
  var isActive: Bool
  
  required init(url: URL, isActive: Bool) {
    self.url = url
    self.isActive = isActive
  }
}
