//
//  ViewController.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 22.09.2020.
//

import UIKit

class ViewController: UIViewController {
  
  typealias Cell = NewsCellData
  typealias Category = NewsCellCategoryData
  typealias ViewCell = FeedTableViewCell
  
  private var tableView: UITableView! = nil
  private var dataSource: UITableViewDiffableDataSource
  <Category, Cell>! = nil
  private var currentSnapshot: NSDiffableDataSourceSnapshot
  <Category, Cell>! = nil
  
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
    
    configureTableView()
    configureDataSource()
    configureRefreshControl()
  }
  
}

// MARK: Configure Refresh Control
extension ViewController {
  func configureRefreshControl () {
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                        for: .valueChanged)
  }
  
  @objc func handleRefreshControl() {
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
      DispatchQueue.main.async {
        self.tableView.refreshControl?.endRefreshing()
      }
    })
    //    DispatchQueue.main.async {
    //      self.tableView.refreshControl?.endRefreshing()
    //    }
  }
}

// MARK: Configure Collection View
extension ViewController {
  
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
extension ViewController {
  
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
      
      return cell
    }
    
    currentSnapshot = NSDiffableDataSourceSnapshot
    <Category, Cell>()
    
    let testCells = [
      Cell(title: "TCS Group подтвердил факт ведения переговоров с \"Яндекс\"",
           publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 * 3 )),
      Cell(title: "Итоги вторника, 22 сентября: Российский рынок нащупал импульс к росту",
           publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 * 4 )),
      Cell(title: "TCS Group подтвердил факт ведения переговоров с \"Яндекс\"",
           publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 * 5 )),
      Cell(title: "Итоги вторника, 22 сентября: Российский рынок нащупал импульс к росту",
           publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 * 6 ))
    ]
    
    let testCategory = Category(channelTitle: "NEWS", news: testCells)
    
    currentSnapshot.appendSections([testCategory])
    currentSnapshot.appendItems(testCategory.news)
    
    dataSource.apply(currentSnapshot, animatingDifferences: false)
  }
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? ActivityIndicatorProtocol else { return }
    
    if cell.isOn {
      cell.toggleIndicator()
    }
    
    let testData = NewsData(title: "TCS Group подтвердил факт ведения переговоров с \"Яндекс\"",
                            content: "TCS Group Holding подтвердил факт ведения переговоров с \"Яндекс\", заявление компании размещено на сайте Лондонской фондовой биржи. \"Стороны пришли к принципиальному соглашению по сделке, которая будет состоять из денежных средств и вознаграждения акциями на сумму около $5,48 млрд или $27,64 за акцию Тинькофф\", - сказано в сообщении кредитной организации. В настоящее время \"Тинькофф\" и \"Яндекс\" намерены осуществить потенциальную сделку по законодательству Кипра. Расписки TCSв моменте подорожали на 6,3%, бумаги \"Яндeкса\" растут на 3,9%.",
                            publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 * 3 ),
                            link: URL(string: "https://yandex.ru")!)
    
    let vc = DetailViewController(news: testData)
    show(vc, sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - Presenting Sources Screen
extension ViewController {
  
  @objc func showSources() {
    let pc = RSSPointCreator()
    
    let points: [RSSPointCellData]
    if let rssPoints = UserDefaults.standard.object(forKey: SettingsModelController.usersDefaultsKey) as? [String : Bool] {
      points = rssPoints.compactMap { link, isActive in
        if let url = URL(string: link) {
          return RSSPointCellData(url: url, isActive: isActive)
        }

        return nil
      }
      
    } else {
      let defaultSources = [
        "https://www.finam.ru/net/analysis/conews/rsspoint" : true,
        "https://www.banki.ru/xml/news.rss" : true,
      ]
      UserDefaults.standard.set(defaultSources, forKey: SettingsModelController.usersDefaultsKey)

      points = defaultSources.compactMap { link, isActive in
        if let url = URL(string: link) {
          return RSSPointCellData(url: url, isActive: isActive)
        }

        return nil
      }
    }
    
    let m = SettingsModelController(rssPoints: points)
    let vc = SettingsViewController(rssPointCreator: pc, model: m)
    
    show(vc, sender: self)
  }
}
