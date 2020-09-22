//
//  NewsCategoryData.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import Foundation

struct NewsCategoryData: NewsCategoryProtocol {
  let channelTitle: String
  
  let channelContent: String
  
  let link: URL
  
  let news: [NewsProtocol]
}
