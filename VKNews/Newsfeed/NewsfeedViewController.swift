//
//  NewsfeedViewController.swift
//  VKNews
//
//  Created by Кирилл Медведев on 26.10.2019.
//  Copyright (c) 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewsfeedCodeCellDelegate {

  var interactor: NewsfeedBusinessLogic?
  var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel.init(cells: [])

    @IBOutlet weak var table: UITableView!
    
    private var titleView = TitleView()
    private var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsfeedInteractor()
    let presenter             = NewsfeedPresenter()
    let router                = NewsfeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTable()
    setupTopBars()
    
    view.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.5058823529, blue: 0.7254901961, alpha: 1)
    interactor?.makeRequest(request: .getNewsfeed)
    interactor?.makeRequest(request: .getUser)
  }
    
    private func setupTopBars() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    private func setupTable() {
        let topInset: CGFloat = 8
        
        table.contentInset.top = topInset
        
        table.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseID)
        table.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        
        table.separatorStyle = .none
        table.backgroundColor = .clear
        
        table.addSubview(refreshControl)
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsfeed)
    
    }
  
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {

    switch viewModel {
    case .displayNewsfeed(let feedViewModel):
        self.feedViewModel = feedViewModel
        table.reloadData()
        refreshControl.endRefreshing()
    
    case .displayUser(let userViewModel):
        titleView.set(userViewModel: userViewModel)
    }
  }
    
    // MARK: - NewsfeedCodeCellDelegate
    
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
  
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseID, for: indexPath) as! NewsfeedCell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellsViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellsViewModel)
        cell.delegate = self
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
}
