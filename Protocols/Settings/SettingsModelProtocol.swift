//
//  SettingsModelProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import UIKit

protocol SettingsModelProtocol {
  
  var rssPoints: [RSSPointProtocol] { get }
  
  mutating func add(_ point: RSSPointProtocol)
  
  mutating func remove(_ point: RSSPointProtocol)
  
  mutating func remove(at index: Int)
  
  mutating func setIsActive(_ isActive: Bool, for index: Int)
}
