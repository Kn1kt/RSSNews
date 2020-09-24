//
//  NewsCellData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

final class NewsCellData: NewsCellProtocol {
  
  let title: String
  
  let publishDate: Date
  
  var unRead: Bool = true
  
  required init(title: String, publishDate: Date) {
    self.title = title
    self.publishDate = publishDate
  }
  
  let identifier = UUID()
}

  // MARK: - Bridge from NewsProtocol
extension NewsCellData {
  
  convenience init(_ news: NewsProtocol) {
    self.init(title: news.title,
              publishDate: news.publishDate)
  }
}
