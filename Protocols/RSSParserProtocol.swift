//
//  RSSParserProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import Foundation

protocol RSSParserProtocol {
  
  func parse(_ data: Data, completionHandler: (_ result: [NewsProtocol]?) -> Void)
}
