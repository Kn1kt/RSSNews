//
//  DetailViewController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class DetailViewController: UIViewController {
  
  typealias News = NewsProtocol
  
  private let news: NewsProtocol
  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.textColor = .label
    textView.font = .preferredFont(forTextStyle: .subheadline)
    textView.dataDetectorTypes = UIDataDetectorTypes([.link])
    
    textView.isEditable = false
    textView.alwaysBounceVertical = true
    textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    return textView
  }()
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    return formatter
  }()
  
  init(news: NewsProtocol) {
    self.news = news
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.title = news.title
    
    setupLayouts()
    
    textView.text = news.content + "\n\n\(dateFormatter.string(from: news.publishDate))\n\(news.link)"
  }
}

extension DetailViewController {
  
  private func setupLayouts() {
    view.addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      textView.topAnchor.constraint(equalTo: view.topAnchor),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
