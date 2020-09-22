//
//  NewsCellCategoryData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

struct NewsCellCategoryData: NewsCellCategoryProtocol {
  typealias News = NewsCellData
  
  let channelTitle: String
  
  var news: [NewsCellData]
  
  let identifier = UUID()
}

// MARK: - Bridge from NewsCategoryProtocol
extension NewsCellCategoryData {
  
  init(_ category: NewsCategoryProtocol) {
    self.init(channelTitle: category.channelTitle,
              news: category.news.map(News.init))
  }
}
