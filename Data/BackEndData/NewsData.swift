//
//  NewsData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

struct NewsData: NewsProtocol {
  
  let title: String
  
  let content: String
  
  let publishDate: Date
  
  let link: URL
}
