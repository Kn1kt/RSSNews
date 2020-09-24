//
//  NewsCellCategoryData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

final class NewsCellCategoryData: NewsCellCategoryProtocol {
  
  typealias News = NewsCellData
  
  var news: [NewsCellData]
  
  let identifier = UUID()
  
  required init(news: [NewsCellData]) {
    self.news = news
  }
}

// MARK: - Bridge from NewsCategoryProtocol
extension NewsCellCategoryData {
  
  convenience init(_ category: NewsCategoryProtocol) {
    self.init(
    news: category.news.map(News.init))
  }
}
