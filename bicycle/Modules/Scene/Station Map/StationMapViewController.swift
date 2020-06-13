//
//  StationMapViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import NMapsMap
import SwiftEntryKit

class StationMapViewController: BaseViewController {
  
  //MARK: - Constant
  
  enum Constant {
    case search, locationError, networkError
    
    var image: UIImage? {
      switch self {
      case .search: return UIImage(named: "Icon-Search")
      default: return nil
      }
    }
    
    var title: String {
      switch self {
      case .search: return "대여소 검색"
      case .locationError: return "원활한 서비스를 위해\n위치서비스를 활성화 시켜주세요.\n\n⚙️ 설정 → bicycle앱 → 위치 활성화"
      case .networkError: return "네트워크 에러!😱\n관리자에게 문의 부탁드립니다."
      }
    }
  }
  
  //MARK: - Properties
  
  let mapView: NMFMapView = {
    let mapView = NMFMapView()
    return mapView
  }()
  
  lazy var stationContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = AppTheme.color.white
    containerView.layer.cornerRadius = 10
    containerView.layer.applyShadow()
    
    let searchImageView: UIImageView = {
      let view = UIImageView()
      view.image = Constant.search.image?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
      view.contentMode = .scaleAspectFit
      view.tintColor = AppTheme.color.main
      return view
    }()
    
    let lineView: UIView = {
      let view = UIView()
      view.backgroundColor = AppTheme.color.separator
      return view
    }()
    
    let searchButton: UIButton = {
      let button = UIButton()
      button.setTitle(Constant.search.title, for: .normal)
      button.setTitleColor(AppTheme.color.gray, for: .normal)
      button.titleLabel?.font = AppTheme.font.custom(size: 14)
      button.contentHorizontalAlignment = .left
      return button
    }()
    
    [searchImageView, lineView, searchButton].forEach{ containerView.addSubview($0) }
    
    searchImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.width.equalTo(searchImageView.snp.height)
    }
    lineView.snp.makeConstraints {
      $0.leading.equalTo(searchImageView.snp.trailing)
      $0.centerY.equalTo(searchImageView)
      $0.height.equalTo(searchImageView.snp.height).dividedBy(2)
      $0.width.equalTo(1)
    }
    searchButton.snp.makeConstraints {
      $0.leading.equalTo(lineView.snp.trailing).offset(16)
      $0.top.bottom.trailing.equalToSuperview()
    }
    
    return containerView
  }()
  
  let viewModel: StationMapViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? StationMapViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupUI() {
    super.setupUI()
    
    for family: String in UIFont.familyNames
    {
        print(family)
        for names: String in UIFont.fontNames(forFamilyName: family)
        {
            print("== \(names)")
        }
    }
    
    [mapView].forEach { view.addSubview($0) }
    [stationContainerView].forEach { mapView.addSubview($0) }
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    stationContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.topNotchHeight + 12)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(54)
    }
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    // Input
    let input = StationMapViewModel.Input(locationGrantTrigger: rx.viewWillAppear.mapToVoid())
    
    // Output
    let output = viewModel?.transform(input: input)
    
    output?.locationGrantPermission.drive(onNext: { [weak self] status in
      if !status {
        self?.toastView.show(image: .error, message: Constant.locationError.title)
      }
    }).disposed(by: rx.disposeBag)
    
    output?.fetchBicycleList.drive(onNext: { [weak self] stations in
      guard stations.count > 0 else {
        self?.toastView.show(image: .error, message: Constant.networkError.title)
        return
      }
    
    }).disposed(by: rx.disposeBag)

  }
  
}
