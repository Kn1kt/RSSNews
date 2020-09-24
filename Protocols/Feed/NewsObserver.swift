//
//  NewsObserverProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 24.09.2020.
//

import Foundation

protocol NewsObserverProtocol {
  associatedtype Category = NewsCellCategoryProtocol
  
  func recieve(_ category: Category)
}
