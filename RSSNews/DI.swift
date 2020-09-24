//
//  DI.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 24.09.2020.
//

import UIKit
import Swinject

class DI {
  
  static let container: Container = {
    let container = Container()
    
    container.register(SourcesProviderProtocol.self) { _ in
      SourcesProvider()
    }
    
    container.register(NewsLoaderProtocol.self) { _ in
      NewsLoader()
    }
    
    container.register(RSSParserProtocol.self) { _ in
      RSSParser<NewsData>()
    }
    
    container.register(RSSPointCreatorProtocol.self) { _ in
      RSSPointCreator()
    }
    
    container.register(SettingsModelProtocol.self) { r in
      SettingsModelController(sourcesProvider: r.resolve(SourcesProviderProtocol.self)!)
    }
    
    container.register(SettingsViewController.self) { r in
      SettingsViewController
      <SettingsTableViewCell>(rssPointCreator: r.resolve(RSSPointCreatorProtocol.self)!,
                              model: r.resolve(SettingsModelProtocol.self)!)
    }
    
    container.register(DetailViewController.self) { _, news in
      DetailViewController(news: news)
    }
    
    container.register(FeedModelController.self) { r in
      FeedModelController
      <NewsCellCategoryData>(sourceProvider: r.resolve(SourcesProviderProtocol.self)!,
                             newsLoader: r.resolve(NewsLoaderProtocol.self)!,
                             rssParser: r.resolve(RSSParserProtocol.self)!)
    }
    
    container.register(FeedViewController.self) { r in
      FeedViewController
      <NewsCellCategoryData, FeedTableViewCell, FeedModelController>(model: r.resolve(FeedModelController.self)!)
    }
    
    return container
  }()
}
