//
//  FavoriteViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RAMAnimatedTabBarController

class FavoriteViewController: BaseViewController {
  
  //MARK: - Constant
  
  enum Constant {
    case naviTitle, naviBackground, refresh
    
    var title: String {
      switch self {
      case .naviTitle: return "즐겨찾기"
      default: return ""
      }
    }
    
    var image: UIImage? {
      switch self {
      case .naviBackground: return UIImage(named: "Header-Background")
      case .refresh: return UIImage(named: "Icon-Navi-Refresh")
      default: return nil
      }
    }
  }
  
  //MARK: - Properties
  let emptyView = EmptyView()
  
  let navigationView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Header-Background")
    return imageView
  }()
  
  let refreshButton: UIButton = {
    let button = UIButton()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(Constant.refresh.image, for: .normal)
    button.tintColor = AppTheme.color.white
    return button
  }()
  
  let naviTitle: UILabel = {
    let label = UILabel()
    label.text = Constant.naviTitle.title
    label.font = AppTheme.font.custom(size: 32)
    label.textColor = AppTheme.color.white
    return label
  }()
  
  let updatedDateLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = AppTheme.font.custom(size: 12)
    label.textColor = AppTheme.color.subline
    return label
  }()
  
  lazy var tableView: BaseTableView = {
    let tableView = BaseTableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = AppTheme.color.white
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    tableView.tableFooterView = UIView()
    tableView.register(FavoriteCell.classForCoder(),
                       forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
    return tableView
  }()
  
  let viewModel: FavoriteViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? FavoriteViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupUI() {
    super.setupUI()
    
    view.backgroundColor = AppTheme.color.subWhite
    
    [navigationView, tableView, refreshButton].forEach { view.addSubview($0) }
    [naviTitle, updatedDateLabel].forEach { navigationView.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(268)
    }
    
    refreshButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.hasTopNotch ? 54 : 24)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.equalTo(26)
      $0.height.equalTo(20)
    }
    
    naviTitle.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-130)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }
    
    updatedDateLabel.snp.makeConstraints {
      $0.top.equalTo(naviTitle.snp.bottom).offset(14)
      $0.leading.equalTo(naviTitle)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(-80)
      $0.bottom.equalToSuperview().offset(-50)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()

    // Input

    let datasource = RxTableViewSectionedAnimatedDataSource<SectionStation>(
      configureCell: { (datasource, tableView, indexPath, station) -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: FavoriteCell.reuseIdentifier, for: indexPath
        ) as? FavoriteCell else { return UITableViewCell() }
        
        cell.configure(with: station)
        
        return cell
    })

    let refresh = tableView.refreshControl!.rx.controlEvent(.valueChanged).mapToVoid()
    let didTapRefresh = refreshButton.rx.tap.asObservable()
    
    let input = FavoriteViewModel.Input(trigger: rx.viewWillAppear.mapToVoid(),
                                        refresh: refresh,
                                        didTapRefresh: didTapRefresh)
    
    // Output
    
    let output = viewModel?.transform(input: input)
    
    output?.likeStationList
      .bind(to: tableView.rx.items(dataSource: datasource))
      .disposed(by: rx.disposeBag)
    
    output?.isLoading
      .drive(onNext: { [weak self] isLoading in
        self?.tableView.refreshControl?.endRefreshing()
      }).disposed(by: rx.disposeBag)
    
    output?.updatedDate
      .drive(onNext: { date in
        self.updatedDateLabel.text = date
      }).disposed(by: rx.disposeBag)
    
    output?.isEmpty
      .drive(onNext: { isEmpty in
        if isEmpty {
          self.view.addSubview(self.emptyView)
          self.emptyView.snp.makeConstraints {
            $0.top.equalTo(self.navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
          }
        } else {
          self.emptyView.removeFromSuperview()
        }
      }).disposed(by: rx.disposeBag)
    
    Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Station.self))
      .subscribe(onNext: { (indexPath, station) in
        if let tabBar = self.tabBarController as? RAMAnimatedTabBarController {
          tabBar.setSelectIndex(from: 1, to: 0)
          AppNotificationCenter.stationDidReceive.post(object: station)
        }
      }).disposed(by: rx.disposeBag)

  }
}

extension FavoriteViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
