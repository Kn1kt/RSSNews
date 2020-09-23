//
//  SettingsModelController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

struct SettingsModelController: SettingsModelProtocol {
  
  static let usersDefaultsKey = "RSSPoints-Key"
  
  private(set) var rssPoints: [RSSPointProtocol]
  
  init(rssPoints: [RSSPointProtocol]) {
//    guard let rssPoints = UserDefaults.standard.object(forKey: Self.usersDefaultsKey) as? [String : Bool] else {
//      let defaultSources = [
//        "https://www.finam.ru/net/analysis/conews/rsspoint" : true,
//        "https://www.banki.ru/xml/news.rss" : true,
//      ]
//      UserDefaults.standard.set(defaultSources, forKey: Self.usersDefaultsKey)
//
//      self.rssPoints = defaultSources.compactMap { link, isActive in
//        if let url = URL(string: link) {
//          return RSSPointProtocol(url: url, isActive: isActive)
//        }
//
//        return nil
//      }
//    }
    
    self.rssPoints = rssPoints
  }
  
  mutating func add(_ point: RSSPointProtocol) {
    rssPoints.append(point)
    
    saveChanges()
  }
  
  mutating func remove(_ point: RSSPointProtocol) {
    if let index = rssPoints.firstIndex(where: { $0.url == point.url }) {
      remove(at: index)
    }
  }
  
  mutating func remove(at index: Int) {
    guard index >= 0,
          index < rssPoints.count else {
      return
    }
    
    rssPoints.remove(at: index)
    
    saveChanges()
  }
  
  mutating func setIsActive(_ isActive: Bool, for index: Int) {
    guard index >= 0,
          index < rssPoints.count else {
      return
    }
    
    rssPoints[index].isActive = isActive
    
    saveChanges()
  }
  
  private func saveChanges() {
    let data = rssPoints.reduce(into: [:]) { result, point in
      result[point.url.absoluteString] = point.isActive
    }
    
    UserDefaults.standard.set(data, forKey: Self.usersDefaultsKey)
  }
}
