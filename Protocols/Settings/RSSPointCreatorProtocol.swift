//
//  RSSPointCreatorProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import UIKit

protocol RSSPointCreatorProtocol {
  
  func getRSSPoint(for recievier: UIViewController, completionHandler: @escaping (_ rssPoint: RSSPointProtocol?) -> Void)
}
