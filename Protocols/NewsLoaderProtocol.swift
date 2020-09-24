//
//  NewsLoaderProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

protocol NewsLoaderProtocol {
  
  func loadNews(from source: RSSPointProtocol, completionHandler: @escaping (_ result: Data?) -> Void)
}
