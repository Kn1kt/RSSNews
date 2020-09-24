//
//  FeedModelController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class FeedModelController<C: NewsCellCategoryProtocol, O: NewsObserverProtocol> where O.Category == C {
  
  typealias News = C.News
  typealias Category = C
  typealias NewsObserver = O
  
  private let sourceProvider: SourcesProviderProtocol
  private let newsLoader: NewsLoaderProtocol
  private let rssParser: RSSParserProtocol
  private let categoryObserver: NewsObserver
  
  init(sourceProvider: SourcesProviderProtocol,
       newsLoader: NewsLoaderProtocol,
       rssParser: RSSParserProtocol,
       categoryObserver: NewsObserver) {
    
    self.sourceProvider = sourceProvider
    self.newsLoader = newsLoader
    self.rssParser = rssParser
    self.categoryObserver = categoryObserver
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
        self.categoryObserver.recieve(self.category)
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
              self.categoryObserver.recieve(self.category)
            }
            return
          }
          
          self.news = (self.news + news).sorted(by: { $0.publishDate > $1.publishDate })
          
          self.category.news = (self.category.news + news.map(News.init)).sorted(by: { $0.publishDate > $1.publishDate })
          
          self.categoryObserver.recieve(self.category)
        })
      }
      
      completionHandler(true)
    }
  }
}
