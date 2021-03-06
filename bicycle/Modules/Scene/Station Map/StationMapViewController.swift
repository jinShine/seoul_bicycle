//
//  StationMapViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

class StationMapViewController: BaseViewController {
  
  //MARK: - ConstantupdatedDate
  
  enum Constant {
    case search, locationError, locationUpdateError,
    networkError, updateLocation, refreshStation,
    compass
    
    var image: UIImage? {
      switch self {
      case .search: return UIImage(named: "Icon-Search")
      case .updateLocation: return UIImage(named: "Icon-LocateMe")
      case .refreshStation: return UIImage(named: "Icon-Refresh")
      case .compass: return UIImage(named: "Icon-Compass")
      default: return nil
      }
    }
    
    var title: String {
      switch self {
      case .search: return "대여소 검색"
      case .locationError: return "원활한 서비스를 위해\n위치서비스를 활성화 시켜주세요.\n\n⚙️ 설정 → bicycle앱 → 위치 활성화"
      case .locationUpdateError: return "위치 업데이트 에러! 😱"
      case .networkError: return "네트워크 에러! 😱\n관리자에게 문의 부탁드립니다."
      default: return ""
      }
    }
    
  }
  
  //MARK: - UI Properties
  
  lazy var mapView: NMFMapView = {
    let mapView = NMFMapView()
    mapView.contentInset = UIEdgeInsets(
      top: self.tabBarController?.tabBar.frame.height ?? 0.0, left: 0, bottom: 0, right: 0
    )
    mapView.mapType = .basic
    mapView.isIndoorMapEnabled = true
    mapView.positionMode = .normal
    mapView.logoAlign = .rightBottom
    mapView.touchDelegate = self
    mapView.addCameraDelegate(delegate: self)
    mapView.addOptionDelegate(delegate: self)
    return mapView
  }()
  
  var markers = [NMFMarker]()
  
  lazy var stationContainerButton: UIButton = {
    let containerView = UIButton()
    containerView.backgroundColor = AppTheme.color.white
    containerView.layer.cornerRadius = 10
    containerView.layer.applyShadow()
    
    let searchImageView: UIImageView = {
      let view = UIImageView()
      view.image = Constant.search.image?.withAlignmentRectInsets(
        UIEdgeInsets(top: -19, left: -19, bottom: -19, right: -19)
      )
      view.contentMode = .scaleAspectFit
      view.tintColor = AppTheme.color.main
      view.isUserInteractionEnabled = false
      return view
    }()
    
    let lineView: UIView = {
      let view = UIView()
      view.backgroundColor = AppTheme.color.separator
      view.isUserInteractionEnabled = false
      return view
    }()
    
    let searchButton: UIButton = {
      let button = UIButton()
      button.setTitle(Constant.search.title, for: .normal)
      button.setTitleColor(AppTheme.color.lightGray, for: .normal)
      button.titleLabel?.font = AppTheme.font.custom(size: 15)
      button.contentHorizontalAlignment = .left
      button.isUserInteractionEnabled = false
      button.tag = Constant.search.hashValue
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
  
  let updateStationButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = AppTheme.color.white
    button.layer.cornerRadius = 12
    button.setImage(Constant.refreshStation.image, for: .normal)
    button.tintColor = AppTheme.color.blueMagenta
    button.layer.applyShadow()
    return button
  }()
  
  let updateLocationButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = AppTheme.color.white
    button.layer.cornerRadius = 12
    button.setImage(Constant.updateLocation.image, for: .normal)
    button.tintColor = AppTheme.color.blueMagenta
    button.layer.applyShadow()
    return button
  }()
  
  var markerInfo: MarkerInfo = {
    let view = MarkerInfo()
    return view
  }()
  
  var updatedDateLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = AppTheme.font.custom(size: 11)
    label.textColor = AppTheme.color.blueMagenta
    label.textAlignment = .right
    return label
  }()
  
  //MARK:- Properties
  
  var rotateAnimationProperty: UIViewPropertyAnimator?
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.removeMarkerInfo()
  }
  
  deinit {
    mapView.removeCameraDelegate(delegate: self)
    mapView.removeOptionDelegate(delegate: self)
  }
  
  override func setupUI() {
    super.setupUI()
    
    [mapView, stationContainerButton, updateStationButton, updateLocationButton, updatedDateLabel].forEach { view.addSubview($0) }
    
    mapView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-(self.tabBarController?.tabBar.frame.height ?? 0.0))
    }
    
    stationContainerButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.topNotchHeight + 12)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(54)
    }
    
    updateStationButton.snp.makeConstraints {
      $0.bottom.equalTo(updateLocationButton.snp.top).offset(-8)
      $0.leading.equalTo(updateLocationButton.snp.leading)
      $0.size.equalTo(44)
    }
    
    updateLocationButton.snp.makeConstraints {
      $0.bottom.equalTo(mapView).offset(-20)
      $0.leading.equalToSuperview().offset(20)
      $0.size.equalTo(44)
    }
    
    updatedDateLabel.snp.makeConstraints {
      $0.top.equalTo(stationContainerButton.snp.bottom).offset(4)
      $0.trailing.equalTo(stationContainerButton)
      $0.leading.equalTo(stationContainerButton)
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    // Input
    
    let viewWillAppear = rx.viewWillAppear.mapToVoid()
    
    let didTapUpdateLocation = updateStationButton.rx.tap
      .do(onNext: { [weak self] _ in self?.rotateLoadingStart() })
      .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
      .mapToVoid()
    
    let didTapLikeInMarkerInfo = markerInfo.likeButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { [weak self] () -> Bool in
          let currentImage = self?.markerInfo.likeButton.currentImage
          guard let isSelected = currentImage?.isEqual(MarkerInfo.Constant.like.image) else { return false }
          return isSelected
      }
      .do(onNext: { self.markerInfo.configureLikeImage(with: $0) })
      .map { isSelected -> (Bool, String) in (isSelected, self.markerInfo.stationNameLabel.text ?? "") }
    
    let input = StationMapViewModel.Input(viewWillAppear: viewWillAppear,
                                          didTapUpdateStation: didTapUpdateLocation,
                                          didTapMoveLocation: updateLocationButton.rx.tap.asObservable(),
                                          didTapStationSearch: stationContainerButton.rx.tap.asObservable(),
                                          didTapLikeInMarkerInfo: didTapLikeInMarkerInfo)
    
    // Output
    
    let output = viewModel?.transform(input: input)
    
    AppNotificationCenter.stationDidReceive.addObserver()
      .bind { object in
        guard let station = object as? Station else { return }
        let lat = Double(station.stationLatitude) ?? 0.0
        let lng = Double(station.stationLongitude) ?? 0.0
        
        self.updateCurrentMoveCamera(lat: lat, lng: lng)
        self.setupMarkerInfo(with: station)
        self.setupSearchButton(with: station)
      }
    .disposed(by: rx.disposeBag)
    
    output?.locationGrantPermission
      .drive(onNext: { [weak self] status in
        if !status {
          self?.toastView.show(image: .error, message: Constant.locationError.title)
        }
      }).disposed(by: rx.disposeBag)
    
    output?.fetchStationList
      .drive(onNext: { [weak self] stations in
        stations.forEach {
          self?.setupStationMarker(with: $0)
        }
      }).disposed(by: rx.disposeBag)
    
    output?.updateLocation
      .drive(onNext: { [weak self] (coordinator, error) in
        if let _ = error {
          self?.toastView.show(image: .error, message: Constant.locationUpdateError.title)
          return
        }
        
        let lat = coordinator.0 ?? 37.5666805
        let lng = coordinator.1 ?? 126.9784147
        self?.mapView.locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
      }).disposed(by: rx.disposeBag)
    
    output?.locationForCameraMove
      .drive(onNext: { [weak self] (lat, lng) in
        self?.updateCurrentMoveCamera(lat: lat, lng: lng)
      }).disposed(by: rx.disposeBag)
    
    output?.updateCurrentLocation
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        
        let position = self.mapView.positionMode
        switch position {
        case .normal:
          self.mapView.positionMode = .direction
          self.updateLocationButton.tintColor = AppTheme.color.main
        case .direction:
          self.mapView.positionMode = .compass
          self.updateLocationButton.setImage(Constant.compass.image, for: .normal)
          self.updateLocationButton.tintColor = AppTheme.color.main
        case .compass:
          self.mapView.positionMode = .direction
          self.updateLocationButton.setImage(Constant.updateLocation.image, for: .normal)
          self.updateLocationButton.tintColor = AppTheme.color.main
        default:
          self.updateLocationButton.setImage(Constant.updateLocation.image, for: .normal)
          self.updateLocationButton.tintColor = AppTheme.color.blueMagenta
        }
      }).disposed(by: rx.disposeBag)
    
    output?.updateStationList
      .drive(onNext: { [weak self] stations in
        self?.rotateLoadingStop()
        self?.removeMarkers()
        self?.removeMarkerInfo()
        DLog(stations)
        stations.forEach {
          self?.setupStationMarker(with: $0)
        }
      }).disposed(by: rx.disposeBag)
    
    output?.showStationSearch
      .drive(onNext: { [weak self] stations in
        let viewModel = StationSearchViewModel(stationLists: Observable.just([SectionStation(model: 0, items: stations)]))
        self?.navigator.show(scene: .stationSearch(viewModel: viewModel), sender: self, animated: false)
      }).disposed(by: rx.disposeBag)
    
    output?.saveAndDeleteStation
      .drive(onNext: { [weak self] stations in
        stations.forEach {
          self?.setupStationMarker(with: $0)
        }
      }).disposed(by: rx.disposeBag)

    output?.updatedDate
      .drive(onNext: { [weak self] date in
        self?.updatedDateLabel.text = date
      }).disposed(by: rx.disposeBag)
    
  }
  
  //MARK:- Methods
  
  private func setupStationMarker(with station: Station) {
    
    let lat = Double(station.stationLatitude) ?? 0.0
    let lng = Double(station.stationLongitude) ?? 0.0
    
    let marker = NMFMarker()
    marker.position = NMGLatLng(lat: lat, lng: lng)
    marker.mapView = self.mapView
    marker.captionText = station.parkingBikeTotCnt
    if station.parkingBikeTotCnt.count >= 2 {
      marker.iconImage = NMFOverlayImage(image: UIImage(named: "Marker_2")!)
    } else {
      marker.iconImage = NMFOverlayImage(image: UIImage(named: "Marker_1")!)
    }
    marker.captionTextSize = 11
    marker.captionAligns = [.topRight]
    marker.captionOffset = -15
    
    marker.touchHandler = { (overlay) -> Bool in
      self.updateCurrentMoveCamera(lat: lat, lng: lng)
      self.setupMarkerInfo(with: station)
      
      return true
    }
    
    markers.append(marker)
  }
  
  private func updateCurrentMoveCamera(lat: Double, lng: Double) {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 17)
    cameraUpdate.animation = .fly
    cameraUpdate.animationDuration = 0.5
    self.mapView.moveCamera(cameraUpdate)
  }
  
  private func removeMarkers() {
    markers.forEach { $0.mapView = nil }
  }
  
  private func rotateLoadingStart() {
    rotateAnimationProperty = UIViewPropertyAnimator
      .runningPropertyAnimator(
        withDuration: 0.5,
        delay: 0,
        options: [.repeat, .curveEaseInOut],
        animations: {
          self.updateStationButton.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
      }, completion: nil)
    rotateAnimationProperty?.startAnimation()
  }
  
  private func rotateLoadingStop() {
    updateStationButton.imageView?.transform = .identity
    rotateAnimationProperty?.stopAnimation(false)
    rotateAnimationProperty?.finishAnimation(at: .current)
  }
  
  private func setupMarkerInfo(with station: Station) {
    view.addSubview(self.markerInfo)
    
    markerInfo.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.height.equalTo(120)
      $0.centerY.equalTo(self.view.center.y - 110)
    }
    
    markerInfo.configure(with: station)
  }
  
  private func removeMarkerInfo() {
    self.markerInfo.removeFromSuperview()
  }
  
  private func setupSearchButton(with station: Station) {
    if let searchButton =  self.stationContainerButton.findSubView(with: Constant.search.hashValue) as? UIButton {
      searchButton.setTitle(station.stationName, for: .normal)
      searchButton.setTitleColor(AppTheme.color.blueMagenta, for: .normal)
    }
  }
  
  private func initSearchButton() {
    if let searchButton =  self.stationContainerButton.findSubView(with: Constant.search.hashValue) as? UIButton {
      searchButton.setTitle(Constant.search.title, for: .normal)
      searchButton.setTitleColor(AppTheme.color.lightGray, for: .normal)
    }
  }
  
  private func reset() {
    initSearchButton()
    removeMarkerInfo()
  }
  
}

extension StationMapViewController: NMFMapViewOptionDelegate, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
  
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    print("LAT :", latlng.lat, "LNG :", latlng.lng)
    reset()
  }
  
  func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
    reset()
    
    //사용자의 제스처로 인해 카메라가 움직였을때 updateLocationButton 초기화
    if reason == NMFMapChangedByGesture {
      self.updateLocationButton.setImage(Constant.updateLocation.image, for: .normal)
      self.updateLocationButton.tintColor = AppTheme.color.blueMagenta
    }
  }
  
}
