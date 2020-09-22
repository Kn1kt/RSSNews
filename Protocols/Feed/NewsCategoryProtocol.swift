//
//  NewsCategoryProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

protocol NewsCategoryProtocol {
  
  var channelTitle: String { get }
  var channelContent: String { get }
  
  var link: URL { get }
  
  var news: [NewsProtocol] { get }
}
