//
//  LocationTrackingViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import os.log
import RxSwift
import RxCocoa
import MapKit

class LocationTrackingViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let rowHeight: CGFloat = 80
  }
  
  
  //MARK: - UI Properties
  @IBOutlet weak var mapView: MKMapView!
  
  
  
  //MARK: - Properties
  typealias ViewModel = LocationTrackingViewModel
  var disposeBag = DisposeBag()
//  var dataSource: RxTableViewSectionedReloadDataSource<SectionOfUserModel>?

  
  init(viewModel: ViewModel) {
    defer {
      self.viewModel = viewModel
    }
    super.init()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
}

//MARK: - Bind
extension LocationTrackingViewController {
  
  //OUTPUT
  func command(viewModel: LocationTrackingViewModel) {
    
    let obViewWillAppear = rx.viewWillAppear.map { _ in
      ViewModel.Command.viewWillAppear
    }
    
    Observable<ViewModel.Command>.merge([
        obViewWillAppear
      ])
      .bind(to: viewModel.command)
      .disposed(by: self.disposeBag)
  }
  
  
  //INPUT
  func state(viewModel: LocationTrackingViewModel) {
    
    viewModel.state
      .drive(onNext: { [weak self] state in
        guard let self = self else { return }
        
        switch state {
        case .viewWillAppearState(latitude: let latitude, longitude: let longitude):
          self.setupMapView(latitude, longitude)
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension LocationTrackingViewController {
  private func setupMapView(_ latitude: Double, _ longitude: Double) {
    self.mapView.delegate = self
    self.mapView.showsUserLocation = true
    
    print("Latitude: \(latitude), Longitude: \(longitude)")
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                   longitude: longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    self.mapView.setRegion(region, animated: true)
  }
}


//MARK: - MKMapViewDelegate
extension LocationTrackingViewController: MKMapViewDelegate {
  
}
