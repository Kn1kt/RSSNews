//
//  ReadIndicatorProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

protocol ActivityIndicatorProtocol {
  
  var isOn: Bool { get }
  
  func toggleIndicator()
}
