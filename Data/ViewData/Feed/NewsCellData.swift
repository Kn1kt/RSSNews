//
//  NewsCellData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

struct NewsCellData: NewsCellProtocol {
  let title: String
  
  let publishDate: Date
  
  let identifier = UUID()
}

  // MARK: - Bridge from NewsProtocol
extension NewsCellData {
  
  init(_ news: NewsProtocol) {
    self.init(title: news.title,
              publishDate: news.publishDate)
  }
}
