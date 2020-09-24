//
//  NewsCategoryData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

class NewsCategoryData: NewsCategoryProtocol {
    
  let news: [NewsProtocol]
  
  required init(news: [NewsProtocol]) {
    self.news = news
  }
}
