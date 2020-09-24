//
//  FeedViewController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class FeedViewController: UIViewController {
  
  typealias Cell = NewsCellData
  typealias Category = NewsCellCategoryData
  typealias ViewCell = FeedTableViewCell
  
  private var tableView: UITableView! = nil
  private var dataSource: UITableViewDiffableDataSource
  <Category, Cell>! = nil
  private var currentSnapshot: NSDiffableDataSourceSnapshot
  <Category, Cell>! = nil
  
  private var model: FeedModelController<Category, FeedViewController>!
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.title = "Feed"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sources",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(showSources))
    
    let s = SourcesProvider()
    let n = NewsLoader()
    let p = RSSParser<NewsData>()
    
    model = FeedModelController(sourceProvider: s, newsLoader: n, rssParser: p, categoryObserver: self)
    
    configureTableView()
    configureDataSource()
    configureRefreshControl()
    
    model.updateNews(completionHandler: { _ in })
  }
  
}

// MARK: Configure Refresh Control
extension FeedViewController {
  func configureRefreshControl () {
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                        for: .valueChanged)
  }
  
  @objc func handleRefreshControl() {
    model.updateNews(completionHandler: { _ in
      DispatchQueue.main.async { [unowned self] in
        if self.currentSnapshot.numberOfItems > 0 {
          self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        self.tableView.refreshControl?.endRefreshing()
      }
    })
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

// MARK: - Table View Delegate
extension FeedViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ActivityIndicatorProtocol else { return }
    
    if cell.isOn {
      cell.toggleIndicator()
      model.category.news[indexPath.row].unRead.toggle()
    }
    
    /// CHECK IT
    let vc = DetailViewController(news: model.news[indexPath.row])
    show(vc, sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - Presenting Sources Screen
extension FeedViewController {
  
  @objc func showSources() {
    let pc = RSSPointCreator()
    let s = SourcesProvider()
    let m = SettingsModelController(sourcesProvider: s)
    
    let vc = SettingsViewController(rssPointCreator: pc, model: m)
    
    show(vc, sender: self)
  }
}

// MARK: - Update Snapshot
extension FeedViewController: NewsObserverProtocol {
  
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
