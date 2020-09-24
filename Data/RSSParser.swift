//
//  RSSParser.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

class RSSParser<News: NewsProtocol>: NSObject, XMLParserDelegate, RSSParserProtocol {
  
  private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
    
    return formatter
  }()
  
  private var news: [News] = []
  
  private var currentElement = ""
  
  private var currentTitle: String = "" {
    didSet {
      currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
  private var currentDescription: String = "" {
    didSet {
      currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
  private var currentPubDate: String = "" {
    didSet {
      currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
  private var currentLink: String = "" {
    didSet {
      currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
  // MARK: - XML Parser Delegate
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
    currentElement = elementName
    
    if currentElement == "item" {
      currentTitle = ""
      currentDescription = ""
      currentPubDate = ""
      currentLink = ""
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    switch currentElement {
    case "title": currentTitle += string
    case "description" : currentDescription += string
    case "pubDate": currentPubDate += string
    case "link": currentLink += string
    default: break
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "item" {
      guard let url = URL(string: currentLink),
            let date = formatter.date(from: currentPubDate) else {
        return
      }
      
      let news = News(title: currentTitle.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil),
                      content: currentDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil),
                      publishDate: date,
                      link: url)
      self.news += [news]
    }
  }
}

// MARK: - RSSParserProtocol
extension RSSParser {
  
  func parse(_ data: Data) -> [NewsProtocol]? {
    let parser = XMLParser(data: data)
    parser.delegate = self
    parser.parse()
    
    defer {
      news = []
    }
    
    return news
  }
}
