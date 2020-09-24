//
//  FeedReusableCellProtocol.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 24.09.2020.
//

import UIKit

protocol FeedReusableCellProtocol: UITableViewCell, ActivityIndicatorProtocol {
  
  static var reuseIdentifier: String { get }
  
  var titleLabel: UILabel { get }
  var dateLabel: UILabel { get }
}
