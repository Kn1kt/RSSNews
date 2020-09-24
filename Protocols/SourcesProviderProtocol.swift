//
//  SourcesProviderProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

protocol SourcesProviderProtocol {
  
  func getSources() -> [RSSPointProtocol]
  
  func updateSources(newData: [RSSPointProtocol])
}
