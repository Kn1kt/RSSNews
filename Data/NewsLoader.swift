//
//  NewsLoader.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class NewsLoader: NewsLoaderProtocol {
  
  func loadNews(from source: RSSPointProtocol, completionHandler: @escaping (Data?) -> Void) {
    URLSession.shared.dataTask(with: source.url) { (data, response, error) in
      
      completionHandler(data)
      
    }.resume()
  }
}
