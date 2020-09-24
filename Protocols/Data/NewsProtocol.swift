//
//  NewsProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

protocol NewsProtocol {
  var title: String { get }
  var content: String { get }
  var publishDate: Date { get }
  
  var link: URL { get }
  
  init(title: String, content: String, publishDate: Date, link: URL)
}
