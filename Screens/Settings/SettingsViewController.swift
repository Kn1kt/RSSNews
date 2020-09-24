//
//  SettingsViewController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class SettingsViewController<V: SettingsReuseCellProtocol>: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  typealias Cell = RSSPointProtocol
  typealias ViewCell = V
  
  private let rssPointCreator: RSSPointCreatorProtocol
  private var model: SettingsModelProtocol
  
  private var tableView: UITableView! = nil
  
  init(rssPointCreator: RSSPointCreatorProtocol, model: SettingsModelProtocol) {
    self.rssPointCreator = rssPointCreator
    self.model = model
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = "Sources"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(createRSSPoint))
    
    configureTableView()
  }
  
  // MARK: Table View Data Source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    model.rssPoints.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewCell.reuseIdentifier, for: indexPath) as? ViewCell else {
      fatalError("Can't create new cell")
    }
    
    let cellData = model.rssPoints[indexPath.row]
    
    cell.titleLabel.text = cellData.url
      .absoluteString
      .removingPercentEncoding?
      .trimmingCharacters(in: .whitespacesAndNewlines)
    
    cell.setIndicator(cellData.isActive)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      model.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  // MARK: - Table View Delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ActivityIndicatorProtocol else {
      return
    }
    
    cell.toggleIndicator()
    model.setIsActive(cell.isOn, for: indexPath.row)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - Create New RSS Point
  @objc func createRSSPoint() {
    rssPointCreator.getRSSPoint(for: self, completionHandler: { [weak self] rssPoint in
      guard let self = self,
            let rssPoint = rssPoint else { return }
      
      let indexPath = IndexPath(row: self.model.rssPoints.count, section: 0)
      self.model.add(rssPoint)
      self.tableView.insertRows(at: [indexPath], with: .automatic)
    })
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
