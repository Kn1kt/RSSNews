//
//  RSSPointProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

protocol RSSPointProtocol {
  
  var url: URL { get }
  
  var isActive: Bool { get set }
}
