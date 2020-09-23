//
//  SettingsTableViewCell.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "settings-cell-reuse-identifier"
  
  private let isActiveIndicatorView = UIImageView()
  let titleLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layouts
extension SettingsTableViewCell {
  
  private func setupLayouts() {
    isActiveIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(isActiveIndicatorView)
    contentView.addSubview(titleLabel)
    
    backgroundColor = .secondarySystemGroupedBackground
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.systemGray.withAlphaComponent(0.4)
    clipsToBounds = true
    
    separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
    
    isActiveIndicatorView.image = UIImage(systemName: "circle.fill")
    isActiveIndicatorView.contentMode = .scaleAspectFill
    isActiveIndicatorView.clipsToBounds = true
    isActiveIndicatorView.tintColor = .systemGreen
    
    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.textColor = .label
    titleLabel.numberOfLines = 0
    titleLabel.adjustsFontForContentSizeCategory = true
    
    let spacing = CGFloat(10)
    NSLayoutConstraint.activate([
      isActiveIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
      isActiveIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
      isActiveIndicatorView.heightAnchor.constraint(equalTo: isActiveIndicatorView.widthAnchor, multiplier: 1.0),
      isActiveIndicatorView.widthAnchor.constraint(equalToConstant: 10),
      
      titleLabel.leadingAnchor.constraint(equalTo: isActiveIndicatorView.trailingAnchor, constant: spacing),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing)
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    isActiveIndicatorView.tintColor = .systemGreen
    isActiveIndicatorView.image = UIImage(systemName: "circle.fill")
  }
}

// MARK: - Read Indicator Protocol
extension SettingsTableViewCell: ActivityIndicatorProtocol {
  
  var isOn: Bool {
    return isActiveIndicatorView.tintColor == UIColor.systemGreen
  }
  
  func toggleIndicator() {
    isActiveIndicatorView.image = isOn ? UIImage(systemName: "circle") : UIImage(systemName: "circle.fill")
    isActiveIndicatorView.tintColor = isOn ? .systemRed : .systemGreen
  }
}
