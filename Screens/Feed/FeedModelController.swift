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
  
  private(set) var news = [NewsProtocol]()
  
  private let queue = DispatchQueue(label: "CategoryQueue", qos: .default)
  var category = Category(news: [])
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
      
      sources
        .forEach { source in
          self.newsLoader.loadNews(from: source, completionHandler: { data in
            guard let data = data else { return }
            
            self.rssParser.parse(data, completionHandler: { news in
              
              guard let news = news else { return }
              self.queue.async {
                
                self.news += news
                self.news.sort(by: { $0.publishDate > $1.publishDate })
                
                self.category.news += news.map(News.init)
                self.category.news.sort(by: { $0.publishDate > $1.publishDate })
                self.categoryObserver.recieve(self.category)
              }
              
            })
          })
        }
      
      completionHandler(true)
    }
  }
}
