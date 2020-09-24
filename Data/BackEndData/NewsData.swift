//
//  NewsData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

class NewsData: NewsProtocol {
  
  let title: String
  
  let content: String
  
  let publishDate: Date
  
  let link: URL
  
  required init(title: String, content: String, publishDate: Date, link: URL) {
    self.title = title
    self.content = content
    self.publishDate = publishDate
    self.link = link
  }
}

extension NewsData: CustomStringConvertible {
  var description: String {
//    "\n\nTITLE: \(title)\nCONTENT: \(content)\nDATE: \(publishDate)\nLINK \(link)"
    "TITLE: \(title)"

  }
}
