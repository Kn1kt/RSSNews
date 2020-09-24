//
//  FeedViewController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class FeedViewController
  <C: NewsCellCategoryProtocol, V: FeedReusableCellProtocol, M: FeedModelControllerProtocol>: UIViewController, UITableViewDelegate where M.Category == C {
  
  typealias Cell = M.Category.News
  typealias Category = M.Category
  typealias ViewCell = V
  typealias Model = M
  
  private var tableView: UITableView! = nil
  private var dataSource: UITableViewDiffableDataSource
    <Category, Cell>! = nil
  private var currentSnapshot: NSDiffableDataSourceSnapshot
    <Category, Cell>! = nil
  
  private var model: Model!
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    
    return formatter
  }()
  
  init(model: Model) {
    self.model = model
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.title = "Feed"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sources",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(showSources))
    
    configureTableView()
    configureDataSource()
    configureRefreshControl()
    
    model.onNextCategoryHandler = recieve
    model.updateNews(completionHandler: { _ in })
  }
  
  // MARK: - Presenting Sources Screen
  @objc func showSources() {
    let vc = DI.container.resolve(SettingsViewController<SettingsTableViewCell>.self)!
    
    show(vc, sender: self)
  }
  
  // MARK: Configure Refresh Control
  private func configureRefreshControl () {
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self,
                                        action: #selector(handleRefreshControl),
                                        for: .valueChanged)
  }
  
  @objc func handleRefreshControl() {
    model.updateNews(completionHandler: { _ in
      DispatchQueue.main.async { [unowned self] in
        self.tableView.refreshControl?.endRefreshing()
      }
    })
  }
  
  // MARK: - Table View Delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ActivityIndicatorProtocol else { return }
    
    if cell.isOn {
      cell.toggleIndicator()
      model.setReadStatus(for: indexPath.row, to: cell.isOn)
    }
    
    let vc = DI.container.resolve(DetailViewController.self, argument: model.news[indexPath.row])!
    show(vc, sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: Configure Collection View
extension FeedViewController {
  
  private func configureTableView() {
    tableView = UITableView(frame: .zero, style: .plain)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .systemBackground
    tableView.alwaysBounceVertical = true
    view.addSubview(tableView)
    
    tableView.delegate = self
    
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

// MARK: Configure Data Source
extension FeedViewController {
  
  private func configureDataSource() {
    dataSource = UITableViewDiffableDataSource
    <Category, Cell> (tableView: tableView) { [weak self] (tableView: UITableView,
                                                           indexPath: IndexPath,
                                                           cellData: Cell) -> UITableViewCell? in
      guard let self = self else { return nil }
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewCell.reuseIdentifier, for: indexPath) as? ViewCell else {
        fatalError("Can't create new cell")
      }
      
      cell.titleLabel.text = cellData.title
      cell.dateLabel.text = self.dateFormatter.string(from: cellData.publishDate)
      cell.setIndicator(cellData.unRead)
      
      return cell
    }
    
    currentSnapshot = NSDiffableDataSourceSnapshot
      <Category, Cell>()
    
    dataSource.apply(currentSnapshot, animatingDifferences: false)
  }
}

// MARK: - Update Snapshot
extension FeedViewController {
  
  func recieve(_ category: Category) {
    DispatchQueue.main.async { [weak self] in
      self?.updateSnapshot(with: category)
    }
  }
  
  private func updateSnapshot(with category: Category) {
    currentSnapshot = NSDiffableDataSourceSnapshot
      <Category, Cell>()
    
    currentSnapshot.appendSections([category])
    currentSnapshot.appendItems(category.news)
      
    dataSource.apply(currentSnapshot, animatingDifferences: true)
  }
}
