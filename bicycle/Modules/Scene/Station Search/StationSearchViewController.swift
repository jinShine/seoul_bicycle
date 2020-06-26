//
//  StationSearchViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/18.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NMapsMap

typealias SectionStation = AnimatableSectionModel<Int, Station>

class StationSearchViewController: BaseViewController {
  
  //MARK: - Constant
  
  enum Constant {
    case search, cancel
    
    var title: String {
      switch self {
      case .search: return "대여소 검색"
      default: return ""
      }
    }
    
    var image: UIImage? {
      switch self {
      case .cancel: return UIImage(named: "Icon-Cancel")
      default: return nil
      }
    }
  }
  
  //MARK: - Properties
  
  let searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constant.search.title
    textField.font = AppTheme.font.custom(size: 15)
    textField.textColor = AppTheme.color.blueMagenta
    return textField
  }()
  
  let dismissButton: UIButton = {
    let button = UIButton()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(Constant.cancel.image, for: .normal)
    button.backgroundColor = AppTheme.color.white
    button.tintColor = AppTheme.color.blueMagenta
    return button
  }()
  
  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = AppTheme.color.main
    return view
  }()
  
  lazy var tableView: BaseTableView = {
    let tableView = BaseTableView(frame: .zero, style: .plain)
    tableView.register(SearchedStationCell.classForCoder(),
                       forCellReuseIdentifier: SearchedStationCell.reuseIdentifier)
    return tableView
  }()
  
  let viewModel: StationSearchViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? StationSearchViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    animateView()
    searchTextField.becomeFirstResponder()
  }
  
  deinit {
    
  }
  
  override func setupUI() {
    super.setupUI()
    
    searchTextField.text = ""
    
    [searchTextField, dismissButton, lineView, tableView].forEach { view.addSubview($0) }
    
    searchTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.topNotchHeight + 12)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalTo(dismissButton.snp.leading).offset(-16)
      $0.height.equalTo(54)
    }
    
    dismissButton.snp.makeConstraints {
      $0.centerY.equalTo(searchTextField)
      $0.trailing.equalToSuperview().offset(-5)
      $0.size.equalTo(searchTextField.snp.height)
    }
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom)
      $0.leading.equalToSuperview().offset(view.center.x)
      $0.trailing.equalToSuperview().offset(-view.center.x)
      $0.height.equalTo(1)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    let datasource = RxTableViewSectionedReloadDataSource<SectionStation>(configureCell: { (datasource, tableView, indexPath, station) -> UITableViewCell in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedStationCell.reuseIdentifier, for: indexPath) as? SearchedStationCell else { return UITableViewCell() }
      
      cell.configure(with: station)
      
      return cell
    })
    
    Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Station.self))
      .subscribe(onNext: { (indexPath, station) in
        self.navigator.dismiss(sender: self, animated: false) {
          print("DISMISS!!!!!")
          AppNotificationCenter.viewDismiss.post(object: station)
        }
      }).disposed(by: rx.disposeBag)
  
  // Input
  
  let searchQuery = searchTextField.rx.text
    .orEmpty
    .asObservable()
  
  let input = StationSearchViewModel.Input(searchQuery: searchQuery,
                                           didTapDismiss: dismissButton.rx.tap.asObservable())
  
  // Output
  
  let output = viewModel?.transform(input: input)
  
  output?.searchedStation
  .bind(to: tableView.rx.items(dataSource: datasource))
  .disposed(by: rx.disposeBag)
  
  output?.dismiss.drive(onNext: { _ in
  self.navigator.dismiss(sender: self, animated: true)
  }).disposed(by: rx.disposeBag)
  
}

//MARK:- Methods

private func animateView() {
  
  // line view
  self.lineView.snp.updateConstraints {
    $0.leading.equalToSuperview().offset(24)
    $0.trailing.equalToSuperview().offset(-24)
  }
  
  UIView.animate(withDuration: 0.35) {
    self.view.layoutIfNeeded()
  }
}
}



