//
//  SourcesProvider.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class SourcesProvider: SourcesProviderProtocol {
  
  private static let usersDefaultsKey = "RSSPoints-Key"
  
  func getSources() -> [RSSPointProtocol] {
    let points: [String : Bool]
    
    if let rssPoints = UserDefaults.standard.object(forKey: Self.usersDefaultsKey) as? [String : Bool] {
      points = rssPoints
      
    } else {
      let defaultSources = [
        "https://www.finam.ru/net/analysis/conews/rsspoint" : true,
        "https://www.banki.ru/xml/news.rss" : true,
      ]
      
      UserDefaults.standard.set(defaultSources, forKey: Self.usersDefaultsKey)
      
      points = defaultSources
    }
    
    var result: [RSSPointCellData] = points
      .compactMap { link, isActive in
        if let url = URL(string: link) {
          return RSSPointCellData(url: url, isActive: isActive)
        }
      
        return nil
      }
    
    let _ = result.partition(by: { !$0.isActive })
    
    return result
  }
  
  func updateSources(newData: [RSSPointProtocol]) {
    let data = newData.reduce(into: [:]) { result, point in
      result[point.url.absoluteString] = point.isActive
    }
    
    UserDefaults.standard.set(data, forKey: Self.usersDefaultsKey)
  }  
}
