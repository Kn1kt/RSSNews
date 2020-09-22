//
//  NewsCellProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

protocol NewsCellProtocol: Hashable {
  
  var title: String { get }
  var publishDate: Date { get }
  
  var identifier: UUID { get }
}

extension NewsCellProtocol {
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
