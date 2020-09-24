//
//  FeedModelControllerProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 24.09.2020.
//

import Foundation

protocol FeedModelControllerProtocol {
  
  associatedtype Category = NewsCellCategoryProtocol
  
  var news: [NewsProtocol] { get }
  var category: Category { get }
  
//  var categoryObserver: NewsObserverProtocol? { get set }
  
  var onNextCategoryHandler: ((_ category: Category) -> Void)? { get set }
  
  func updateNews(completionHandler: @escaping (_ done: Bool) -> Void)
  
  func setReadStatus(for index: Int, to bool: Bool)
}
