//
//  SettingsModelController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class SettingsModelController: SettingsModelProtocol {
  
  private(set) var rssPoints: [RSSPointProtocol]
  private let sourcesProvider: SourcesProviderProtocol
  
  init(sourcesProvider: SourcesProviderProtocol) {
    self.sourcesProvider = sourcesProvider
    self.rssPoints = sourcesProvider.getSources()
  }
  
  func add(_ point: RSSPointProtocol) {
    rssPoints.append(point)
    
    saveChanges()
  }
  
  func remove(_ point: RSSPointProtocol) {
    if let index = rssPoints.firstIndex(where: { $0.url == point.url }) {
      remove(at: index)
    }
  }
  
  func remove(at index: Int) {
    guard (0..<rssPoints.count) ~= index else {
      return
    }
    
    rssPoints.remove(at: index)
    
    saveChanges()
  }
  
  func setIsActive(_ isActive: Bool, for index: Int) {
    guard (0..<rssPoints.count) ~= index else {
      return
    }
    
    rssPoints[index].isActive = isActive
    
    saveChanges()
  }
  
  private func saveChanges() {
    sourcesProvider.updateSources(newData: rssPoints)
  }
}
