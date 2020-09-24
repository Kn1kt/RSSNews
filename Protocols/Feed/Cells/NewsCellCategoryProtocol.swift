//
//  NewsCellCategoryProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

protocol NewsCellCategoryProtocol: Hashable {
  
  associatedtype News: NewsCellProtocol
  
  var news: [News] { get set }
  
  var identifier: UUID { get }
  
  init(news: [News])
  
  init(_ category: NewsCategoryProtocol)
}

extension NewsCellCategoryProtocol {
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
