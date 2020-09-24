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
  
  var unRead: Bool { get set }
  
  var identifier: UUID { get }
  
  init(title: String, publishDate: Date)
  init(_ news: NewsProtocol)
}

extension NewsCellProtocol {
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

extension NewsCellProtocol {
  init(title: String, publishDate: Date, unRead: Bool = true) {
    self.init(title: title, publishDate: publishDate)
    
    self.unRead = unRead
  }
}
