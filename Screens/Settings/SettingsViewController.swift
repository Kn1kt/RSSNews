//
//  SettingsViewController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class SettingsViewController: UIViewController {
  
  typealias Cell = RSSPointProtocol
  typealias ViewCell = SettingsTableViewCell
  
  private var tableView: UITableView! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = "Sources"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: nil)
    
    configureTableView()
  }
  
}

  // MARK: Configure Collection View
extension SettingsViewController {
  
  private func configureTableView() {
    tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .systemGroupedBackground
    tableView.alwaysBounceVertical = true
    view.addSubview(tableView)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    tableView.register(ViewCell.self,
                       forCellReuseIdentifier: ViewCell.reuseIdentifier)
  }
}
  
  // MARK: Table View Data Source
extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewCell.reuseIdentifier, for: indexPath) as? ViewCell else {
      fatalError("Can't create new cell")
    }
    
    switch indexPath.row {
    case 0:
      cell.titleLabel.text = "https://www.finam.ru/net/analysis/conews/rsspoint"
    default:
      cell.titleLabel.text = "https://www.banki.ru/xml/news.rss"
    }
    
    return cell
  }
  
  
}

extension SettingsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ActivityIndicatorProtocol else {
      return
    }
    
    cell.toggleIndicator()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
