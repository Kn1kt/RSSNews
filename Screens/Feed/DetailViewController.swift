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
    textView.dataDetectorTypes = UIDataDetectorTypes([.link])
    
    textView.isEditable = false
    textView.alwaysBounceVertical = true
    textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
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
    
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = news.title
    
    setupLayouts()
    reflowTextAttributes()
  }
}

  // MARK: - Setup Layouts
extension DetailViewController {
  
  private func setupLayouts() {
    textView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      textView.topAnchor.constraint(equalTo: view.topAnchor),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    reflowTextAttributes()
  }
}

// MARK: - Update TextView
extension DetailViewController {
  
  private func reflowTextAttributes() {
    let rawText = news.title + "\n\n" + news.content + "\n\n\(dateFormatter.string(from: news.publishDate))\n\(news.link)"
    
    let attributedText = NSMutableAttributedString(string: rawText)
    let text = rawText as NSString
    
    let entireRange = NSRange(location: 0, length: attributedText.length)
    let boldRange = text.range(of: news.title)
    
    let boldFontDescriptor = UIFont
      .preferredFont(forTextStyle: .title3)
      .fontDescriptor
      .withSymbolicTraits(.traitBold) ?? UIFont.preferredFont(forTextStyle: .title3).fontDescriptor
    
    let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0)
    let font = UIFont.preferredFont(forTextStyle: .body)
    
    attributedText.addAttribute(.font, value: font, range: entireRange)
    attributedText.addAttribute(.font, value: boldFont, range: boldRange)
    
    textView.attributedText = attributedText
    textView.textColor = .label
  }
}
