//
//  FeedTableViewCell.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class FeedTableViewCell: UITableViewCell, FeedReusableCellProtocol {
  
  static let reuseIdentifier = "feed-cell-reuse-identifier"
  
  private let readIndicatorView = UIImageView()
  let titleLabel = UILabel()
  let dateLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layouts
extension FeedTableViewCell {
  
  private func setupLayouts() {
    readIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(readIndicatorView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(dateLabel)
    
    backgroundColor = .systemBackground
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.systemGray.withAlphaComponent(0.4)
    clipsToBounds = true
    
    separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
    
    accessoryType = .disclosureIndicator
    
    readIndicatorView.image = UIImage(systemName: "circle.fill")
    readIndicatorView.contentMode = .scaleAspectFill
    readIndicatorView.clipsToBounds = true
    readIndicatorView.tintColor = .systemBlue
    
    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.textColor = .label
    titleLabel.numberOfLines = 0
    titleLabel.adjustsFontForContentSizeCategory = true
    
    dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    dateLabel.textColor = .secondaryLabel
    dateLabel.numberOfLines = 1
    dateLabel.adjustsFontForContentSizeCategory = true
    dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    dateLabel.setContentHuggingPriority(.required, for: .horizontal)
    
    let spacing = CGFloat(10)
    NSLayoutConstraint.activate([
      readIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
      readIndicatorView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 0),
      readIndicatorView.heightAnchor.constraint(equalTo: readIndicatorView.widthAnchor, multiplier: 1.0),
      readIndicatorView.widthAnchor.constraint(equalToConstant: 10),
      
      titleLabel.leadingAnchor.constraint(equalTo: readIndicatorView.trailingAnchor, constant: spacing),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
      
      dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: spacing),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
      dateLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
      dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -spacing),
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    readIndicatorView.isHidden = false
  }
}

// MARK: - Read Indicator Protocol
extension FeedTableViewCell: ActivityIndicatorProtocol {
  
  var isOn: Bool {
    return !readIndicatorView.isHidden
  }
  
  func toggleIndicator() {
    readIndicatorView.isHidden.toggle()
  }
}
