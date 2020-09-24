//
//  FeedModelController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class FeedModelController
<C: NewsCellCategoryProtocol>: FeedModelControllerProtocol {
    
  typealias News = C.News
  typealias Category = C
  
  private let sourceProvider: SourcesProviderProtocol
  private let newsLoader: NewsLoaderProtocol
  private let rssParser: RSSParserProtocol
  
  /// Contains news that alredy viewed
  private var showed = Set<String>()
  
  var onNextCategoryHandler: ((Category) -> Void)?
  
  init(sourceProvider: SourcesProviderProtocol,
       newsLoader: NewsLoaderProtocol,
       rssParser: RSSParserProtocol) {
    
    self.sourceProvider = sourceProvider
    self.newsLoader = newsLoader
    self.rssParser = rssParser
  }
  
  private var _news = [NewsProtocol]()
  private let newsQueue = DispatchQueue(label: "NewsQueue", attributes: .concurrent)
  
  private(set) var news: [NewsProtocol] {
    get {
      newsQueue.sync {
        return _news
      }
    }
    
    set {
      newsQueue.async(flags: .barrier) { [unowned self] in
        self._news = newValue
      }
    }
  }
  
  private var _category = Category(news: [])
  private let categoryQueue = DispatchQueue(label: "CategoryQueue", attributes: .concurrent)
  
  private(set) var category: Category {
    get {
      categoryQueue.sync {
        return _category
      }
    }
    
    set {
      categoryQueue.async(flags: .barrier) { [unowned self] in
        self._category = newValue
      }
    }
  }
}

// MARK: - Updating News
extension FeedModelController {
  
  func updateNews(completionHandler: @escaping (_ done: Bool) -> Void) {
    news = []
    category = Category(news: [])
    
    DispatchQueue.global().async { [weak self] in
      guard let self = self else {
        completionHandler(true)
        return
      }
      
      let sources = self.sourceProvider.getSources().filter { $0.isActive }
      guard !sources.isEmpty else {
        self.onNextCategoryHandler?(self.category)
        completionHandler(true)
        return
      }
      
      sources.forEach { source in
        self.newsLoader.loadNews(from: source, completionHandler: { [weak self] data in
          guard let self = self else {
            return
          }
          
          guard let data = data,
                let news = self.rssParser.parse(data) else {
            if self.category.news.isEmpty {
              self.onNextCategoryHandler?(self.category)
            }
            return
          }
          
          self.news = (self.news + news).sorted(by: { $0.publishDate > $1.publishDate })
          
          let mapped: [News] = news.map { news in
            News.init(title: news.title, publishDate: news.publishDate, unRead: !self.showed.contains(news.title))
          }
          
          self.category.news = (self.category.news + mapped).sorted(by: { $0.publishDate > $1.publishDate })
          
          self.onNextCategoryHandler?(self.category)
        })
      }
      
      completionHandler(true)
    }
  }
}

// MARK: - Updating Read Status News
extension FeedModelController {
  
  func setReadStatus(for index: Int, to bool: Bool) {
    guard (0..<category.news.count) ~= index else {
      return
    }
    
    category.news[index].unRead = bool
    
    if bool == false {
      showed.insert(category.news[index].title)
    }
  }
}
