//
//  NewsCategoryProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

protocol NewsCategoryProtocol {
  
  var news: [NewsProtocol] { get }
  
  init(news: [NewsProtocol])
}
